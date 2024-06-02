# NVAlert Package

**Important**: 👷‍♂️ This package is currently **under construction**, and may change at any time.

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
