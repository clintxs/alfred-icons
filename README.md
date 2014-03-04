![Automatically switch to light icons on a dark theme.](http://clintonstrong.com/i/9fdb7c.png)

Bundle both light and dark icons with your theme, and let alfred-icons decide which ones to use. This eliminates the need to maintain two separate workflows for light and dark themes; it just works.

To sum up how it works: alfred-icons analyzes the background color of the user's current theme and swaps out the icons based on whether it's light or dark.

## How to use

To put it in use, you'll need to conform to a simple naming convention. Alfred already names the icons for you, based on a UUID -- something like `3A20DDBC-D992-4DD1-9A65-4A1860EEEC7D.png`. For the sake of explanation, let's assume the default icons are dark (i.e. designed for light themes). Now you can add in the light variant of your icon. You'll want to give it the same name as its corresponding dark icon, but  with "-light" appended to the end. So for example, you'd name the new icon `3A20DDBC-D992-4DD1-9A65-4A1860EEEC7D-light.png`. If your default icons are light (i.e. designed for dark themes), append "-dark" instead.

So to clarify, add the "-light" prefix to light icons designed for dark themes, and "-dark" to dark icons designed for light themes. Don't rename the original icons Alfred generates for you.

Now that you have the icons set up, [download the latest release](https://github.com/clintxs/alfred-icons/releases) and place `SetupIconsForTheme` into your workflow's folder. It's up to you how you want it to run: you could add in a keyword for manually changing the icon colors, or you could automate the process and run it every time your script/script filter is run.

## Including it in your script

In Ruby and PHP, you can run it by including the command in backticks:

```ruby
`./SetupIconsForTheme`
```

In Python, you can use subprocess:

```python
import subprocess
subprocess.call('./SetupIconsForTheme')
```

You may need to adjust the path if your script is stored in a subdirectory, but you get the idea.

## Other notes

The one drawback -- and this is still the case even if you have separate "light" and "dark" workflows -- is that the background color for the *selected* result might have a dark background, while the rest of the theme is light. This could cause "invisible" or hard to see icons for the selected result, while everything else looks fine. Unfortunately, we can't change the icon for just the selected result -- it has to use the same icon for every result. You could work around the issue entirely by adding backgrounds to your icons, but then you lose out on the clean, simple look of monochromatic icons . I'll leave that decision up to you.

Note that there's a bit of delay before the script recognizes that you've switched themes. If you're testing it out and it doesn't work right away, just give it a few seconds and try again.

## Ideas for future improvements

- Use a cache file so it doesn't run on every keystroke. Maybe limit it to 30 seconds or a minute so it's still responsive to changes by the user, but it won't run needlessly.

- Check if Alfred's preferences have changed since the last run. If they have, it's possible the user might have changed their theme. If not, we know the theme didn't change, so there's no need to run it again.

- Generate the dark or light icons for you, without needing an image editor. Not guaranteed, but I'll consider it for a future release.
