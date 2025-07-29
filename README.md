# newBind

A hoverbind addon for World of Warcraft 1.12 (Vanilla) that allows you to bind keys to action bar buttons by hovering over them and pressing the desired key combination.

## Features

- **Hover to Bind**: Simply hover over any action bar button and press a key to bind it
- **Modifier Support**: Supports Alt, Ctrl, and Shift modifiers
- **Mouse Button Binding**: Can bind mouse buttons and mouse wheel
- **Escape to Clear**: Press Escape while hovering over a button to remove its binding
- **Combat Protection**: Automatically disables during combat
- **Default UI Compatible**: Works with the default WoW UI, not requiring pfUI

## Usage

1. Type `/newbind` or `/nb` in chat to activate hoverbind mode
2. Hover over any action bar button
3. Press the key combination you want to bind
4. Press Escape while hovering over a button to remove its binding
5. Click on empty space or press Escape to exit hoverbind mode

## Supported Action Bars

- Main action bar (ActionButton1-12)
- Multi-action bars (MultiBarBottomLeft, MultiBarBottomRight, MultiBarRight, MultiBarLeft)
- Pet action bar (PetActionButton1-10)
- Shapeshift/Stance bar (ShapeshiftButton1-10)

## Key Combinations

- **Single Keys**: A-Z, 1-9, 0, F1-F12, etc.
- **Modifier Combinations**: Alt+A, Ctrl+Shift+1, etc.
- **Mouse Buttons**: Left, Right, Middle, Button4, Button5
- **Mouse Wheel**: MouseWheelUp, MouseWheelDown

## Installation

1. Download the addon files
2. Place the `newBind` folder in your `Interface/AddOns` directory
3. Restart World of Warcraft
4. Enable the addon in the addon list

## Commands

- `/newbind` - Activate hoverbind mode
- `/kb` - Short command for hoverbind mode

## Notes

- The addon automatically saves bindings when you create them
- Bindings are cleared when you press Escape while hovering over a button
- The addon is disabled during combat for safety
- Works with the default WoW UI, no additional UI addons required. Fully functionnal with Dragonflight : Reloaded UI and maybe others.

## Credits

Based on the hoverbind functionality from pfUI but adapted for the default WoW UI. 