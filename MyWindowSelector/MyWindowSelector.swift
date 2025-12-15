import Cocoa
import Carbon


enum StateMachineState {
    case initial
    case selectApplication
    case selectVirtualDesktop
}

var currentState = StateMachineState.initial
var timeoutTimer: Timer?

func resetToInitialState() {
    currentState = .initial
    timeoutTimer?.invalidate()
    timeoutTimer = nil

}

func startTimeout() {
    timeoutTimer?.invalidate()
    timeoutTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
        resetToInitialState()
    }
}


struct KeyMappingInput: Hashable {
    let beforeState: StateMachineState
    let modifiers: CGEventFlags
    let keycode: Int

    init(_ modifiers: CGEventFlags, _ keycode: Int) {
        self.init(.initial, modifiers, keycode)
    }

    init(_ beforeState: StateMachineState, _ modifiers: CGEventFlags, _ keycode: Int) {
        self.beforeState = beforeState
        self.modifiers = modifiers
        self.keycode = keycode
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(beforeState)
        hasher.combine(modifiers.rawValue)
        hasher.combine(keycode)
    }
}

struct KeyMappingOutput {
    let operation: () -> Void
    let afterState: StateMachineState

    init(_ operation: @escaping () -> Void) {
        self.init(operation, .initial)
    }

    init(_ afterState: StateMachineState) {
        self.init({}, afterState)
    }

    init(_ operation: @escaping () -> Void, _ afterState: StateMachineState) {
        self.operation = operation
        self.afterState = afterState
    }
}

func openApplication(_ applicationName: String) {
    NSWorkspace.shared.runningApplications
        .first { $0.localizedName == applicationName }?
        .activate()
}

// Works because I setup mission control keyboard shortcut, which are longer and inconvenient to press
// The purpose of this script is to replace this with a prefix-based keyboard shortcut
func switchToDesktop(missionControlKeycode: Int) {
    let keycode = CGKeyCode(missionControlKeycode)
    let flags: CGEventFlags = [.maskShift, .maskControl, .maskAlternate, .maskCommand]

    if let keyDown = CGEvent(keyboardEventSource: nil, virtualKey: keycode, keyDown: true),
       let keyUp = CGEvent(keyboardEventSource: nil, virtualKey: keycode, keyDown: false) {
        keyDown.flags = flags
        keyUp.flags = flags
        keyDown.post(tap: .cghidEventTap)
        keyUp.post(tap: .cghidEventTap)
    }
}

var keyMappings = [
    KeyMappingInput(CGEventFlags([.maskCommand, .maskShift]), kVK_ANSI_A): KeyMappingOutput(.selectApplication),
    KeyMappingInput(CGEventFlags([.maskCommand, .maskShift]), kVK_ANSI_D): KeyMappingOutput(.selectVirtualDesktop),
]

func addLenientShortcut(_ beforeState: StateMachineState, _ keycode: Int, _ operation: @escaping () -> Void) {
    let subModifierCombinations = [
        CGEventFlags([]),
        CGEventFlags([.maskCommand]),
        CGEventFlags([.maskShift]),
        CGEventFlags([.maskCommand, .maskShift]),
    ]

    for modifiers in subModifierCombinations {
        let keyMappingInput = KeyMappingInput(beforeState, modifiers, keycode)
        let keyMappingOutput = KeyMappingOutput(operation)
        keyMappings[keyMappingInput] = keyMappingOutput
    }
}


// Select application shortcuts
addLenientShortcut(.selectApplication, kVK_ANSI_M, { openApplication("Microsoft Outlook") }) // M for mail or meetings
addLenientShortcut(.selectApplication, kVK_ANSI_S, { openApplication("Slack") })
addLenientShortcut(.selectApplication, kVK_ANSI_F, { openApplication("Firefox") })
addLenientShortcut(.selectApplication, kVK_ANSI_E, { openApplication("iTerm2") }) // E for "editor"

// This one works, but for some reason not when zoom is in fullscreen
addLenientShortcut(.selectApplication, kVK_ANSI_Z, { openApplication("zoom.us") })


// Switch to virtual desktop shortcuts
addLenientShortcut(.selectVirtualDesktop, kVK_ANSI_A, { switchToDesktop(missionControlKeycode: kVK_ANSI_A)} )
addLenientShortcut(.selectVirtualDesktop, kVK_ANSI_S, { switchToDesktop(missionControlKeycode: kVK_ANSI_S)} )
addLenientShortcut(.selectVirtualDesktop, kVK_ANSI_D, { switchToDesktop(missionControlKeycode: kVK_ANSI_D)} )
addLenientShortcut(.selectVirtualDesktop, kVK_ANSI_F, { switchToDesktop(missionControlKeycode: kVK_ANSI_F)} )
addLenientShortcut(.selectVirtualDesktop, kVK_ANSI_G, { switchToDesktop(missionControlKeycode: kVK_ANSI_G)} )
addLenientShortcut(.selectVirtualDesktop, kVK_ANSI_H, { switchToDesktop(missionControlKeycode: kVK_ANSI_H)} )
addLenientShortcut(.selectVirtualDesktop, kVK_ANSI_J, { switchToDesktop(missionControlKeycode: kVK_ANSI_J)} )
addLenientShortcut(.selectVirtualDesktop, kVK_ANSI_K, { switchToDesktop(missionControlKeycode: kVK_ANSI_K)} )
addLenientShortcut(.selectVirtualDesktop, kVK_ANSI_L, { switchToDesktop(missionControlKeycode: kVK_ANSI_L)} )


enum EventPropagationOption {
    case swallow
    case passToActiveWindow
}

func handleKeyPress(_ modifiers: CGEventFlags, _ keycode: Int) -> EventPropagationOption {
    let keyMappingInput = KeyMappingInput(currentState, modifiers, keycode)

    if let keyMappingOutput = keyMappings[keyMappingInput] {
        keyMappingOutput.operation()

        switch keyMappingOutput.afterState {
            case .initial:
                resetToInitialState()

            default:
                currentState = keyMappingOutput.afterState
                startTimeout()
        }
        return .swallow
    }

    // No keyMapping was found
    switch currentState {
        case .initial:
            return .passToActiveWindow

        default:
            resetToInitialState()
            return .swallow
    }
}



// macOSModifiers include other things like whether or not Caps Lock is active now
// https://developer.apple.com/documentation/coregraphics/cgeventflags
// I don't want this to affect the keyboard shortcuts at all
// So remove those flags from the set before comparing
func simplifyModifiers(macOSModifiers: CGEventFlags) -> CGEventFlags {
    let modifiersICareAboutMask = CGEventFlags([.maskShift, .maskControl, .maskAlternate, .maskCommand]).rawValue
    let rawModifiers = macOSModifiers.rawValue & modifiersICareAboutMask
    return CGEventFlags(rawValue: rawModifiers)
}

// Boilerplate for creating something that listens for keydown events
// https://gaitatzis.medium.com/capture-key-bindings-in-swift-3050b0ccbf42
if let tap = CGEvent.tapCreate(
    tap: .cgSessionEventTap,
    place: .headInsertEventTap,
    options: .defaultTap,
    eventsOfInterest: CGEventMask(1 << CGEventType.keyDown.rawValue),
    callback: { _, _, event, _ in
        let modifiers = simplifyModifiers(macOSModifiers: event.flags)
        let keycode = Int(event.getIntegerValueField(.keyboardEventKeycode))

        let eventPropagationOption = handleKeyPress(modifiers, keycode)
        switch eventPropagationOption {
            case .passToActiveWindow:
                return Unmanaged.passUnretained(event)
            case .swallow:
                return nil
        }
    },
    userInfo: nil
) {
    let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
    CFRunLoopAddSource(CFRunLoopGetMain(), source, .commonModes)
    CGEvent.tapEnable(tap: tap, enable: true)
    CFRunLoopRun()
} else {
    print("Failed to create tap, likely due to a permission error")
    print("Check permissions under System Settings -> Privacy & Security -> Accessibility")
    // An exit code of 13 typically is an access denied
    exit(13)
}

