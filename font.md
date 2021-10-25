- [Links](#links)
- [Chrome](#chrome)
____

### Links

- [Nerd Fonts - Cheat Sheet](https://www.nerdfonts.com/cheat-sheet)
- [DejaVu Sans Mono Nerd
  Font](https://github.com/blinksh/fonts/blob/master/DejaVu%20Sans%20Mono%20Nerd%20Font.css)
  - used in blinksh on iOS

### Chrome

The following css can be applied to both Crostini and Secure Shell. The drawback
is that the font will be retrieve from the internet.

```css
@font-face {
    font-family: "DejaVu Sans Mono Nerd";
    src: url("https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono.ttf");
    font-weight: normal;
    font-style: normal;
}
```

In Crostini, the setting page can be brought up by
[chrome-untrusted://terminal/html/nassh_preferences_editor.html](chrome-untrusted://terminal/html/nassh_preferences_editor.html).

