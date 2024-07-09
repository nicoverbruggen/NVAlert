# NVAlert Package

## What is this?

This is a package that helps you present larger alerts (with more text) for macOS, if you dislike the smaller alerts introduced in more recent versions of macOS.

Since PHP Monitor displays many helpful prompts, I wanted something a little bit more robust than the default alerts which ship with macOS.

This was originally written as part of my "zero non first-party dependencies" policy for [PHP Monitor](https://github.com/nicoverbruggen/phpmon).

## Example usage

```swift
NVAlert().withInformation(
    title: NSLocalizedString("lite_mode_explanation.title", nil),
    subtitle: NSLocalizedString("lite_mode_explanation.subtitle", nil),
    description: NSLocalizedString("lite_mode_explanation.description", nil)
)
.withPrimary(text: NSLocalizedString("generic.ok", nil))
.show()
```

### Additional buttons

The other chainable methods you can call are:

- `withSecondary(text: String, action: (@MainActor (NVAlertVC) -> Void)?)`
- `withTertiary(text: String, action: (@MainActor (NVAlertVC) -> Void)?)`

A second button can be added by using `withSecondary` and you can add a third button by using `withTertiary`.

**Note**: It currently isn't possible to add more than three buttons. It's a bad user experience to have too many buttons for a single alert, so this is rather intentional.

### Help button

If you would like to have a "help" button for informative purposes, you can leave the `text` property of `withTertiary` empty, and the button's `.bezelStyle` will be set to `.helpButton`.

### Setting actions for buttons

#### Primary button

You must always manually set the action for each button, except for a `withPrimary` call. 

For a **primary** button interaction, the default callback will simply close the alert without doing anything extra, like an "OK" button which is supposed to be used to acknowledge information without any additional things happening.

This is because of the method signature's default argument for `action`:

```swift
public func withPrimary(
    text: String,
    action: @MainActor @escaping (NVAlertVC) -> Void = { vc in
        vc.close(with: .alertFirstButtonReturn)
    }
)
```

#### Secondary and tertiary buttons

If an action for a **secondary or tertiary** button is not set, the button will not be displayed.

An example usage of an action may be something like this:

```swift
NVAlert().withInformation(
    title: "A new component is available",
    subtitle: "Would you like to install this component?"
)
.withPrimary(
    text: "Install",
    action: { vc in
        // First, close the alert
        vc.close(with: .OK)

        // Run additional code after closing
        self.performInstallation()
    }
).show()
```

If the user now presses the "Install" button, the action callback closure will be executed.