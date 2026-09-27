# Non-functional Requirements

## NFR-001: Mobile Performance

Status: Accepted  
Priority: Must  
Phase: MVP

- The application must be optimized for mobile devices and slow networks.
- UI code must not depend directly on SQL or storage provider details.
- Repository boundaries must preserve compatibility with a future NestJS backend.

## NFR-002: Cross-platform Availability

Status: Proposed
Priority: Must
Phase: To be determined

- The product must provide a supported experience on smartphones and tablets, and in web browsers on phones, tablets, desktops, and laptops.
- Platform-specific behavior and exceptions must be stated in the relevant feature requirement. Requirements apply across supported clients unless a platform or form factor is explicitly named.
- The supported operating system, browser, and version matrix must be defined and published for each release. The product must not claim compatibility with every device or browser version.

## NFR-003: Responsive Layout

Status: Proposed
Priority: Must
Phase: To be determined

- Screens must adapt to the available viewport size and orientation on supported devices.
- Essential content and actions must remain available without unintended clipping or horizontal scrolling.
- Layout changes must not change the meaning or outcome of an action. Intentional interaction differences by platform or form factor must be documented in the relevant feature requirement.

## NFR-004: Accessible Interaction

Status: Proposed
Priority: Must
Phase: To be determined

- Core tasks must be operable with the input methods supported by the client, including touch, keyboard, and pointer input where available.
- Interactive controls and meaningful content must expose accessible names and semantics to platform assistive technologies.
- Essential information and actions must not rely on color, sound, hover, or gesture alone.
- Text and controls must remain usable with system text scaling and browser zoom.

## NFR-005: Browser Behavior

Status: Proposed
Priority: Must
Phase: To be determined

- Browser-based clients must support browser navigation, including Back, without unexpectedly discarding user input or leaving the application in an inconsistent state.
- Browser-specific behavior, including permissions, downloads, and opening external links, must follow the relevant browser's expected interaction patterns and be documented in the affected feature requirement when behavior differs.

## NFR-006: Network and Operation Feedback

Status: Proposed
Priority: Must
Phase: To be determined

- Network-dependent actions must provide clear pending, success, and failure feedback.
- A temporary network failure must not silently discard user input or report an unsuccessful action as successful.
- Retrying an action must not create unintended duplicate effects.