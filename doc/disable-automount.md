
# Disable automatic mounting of removable media

In order to minimise any risks of accidental write actions to floppy disks, it is strongly suggested to disable automatic mounting of removable media. The exact command depends on the Linux desktop you're using. For the [MATE](https://mate-desktop.org/) desktop use this:

```bash
gsettings set org.mate.media-handling automount false
```

For a [GNOME](https://www.gnome.org/) desktop use this command:

```bash
gsettings set org.gnome.desktop.media-handling automount false
```

And for the [Cinnamon](https://projects.linuxmint.com/cinnamon/) desktop:

```bash
gsettings set org.cinnamon.desktop.media-handling automount-open false
```

You can use the below command to verify the automount setting (MATE):

```bash
gsettings get org.mate.media-handling automount
```

Or, for GNOME:

```bash
gsettings get org.gnome.desktop.media-handling automount
```

And finally for Cinnamon:

```bash
gsettings get org.cinnamon.desktop.media-handling automount-open 
```

If all goes well, this will result in:

```
false
```

Please be aware that disabling the automount feature does not provide tamper-proof write blocking! It only works at the level of the operating system's default file manager, and it won't keep a user from manually mounting a device. Also, the *gsettings* command only works at the user level. This means that for someone who logs in with a different user name, the default automount setting applies (which means automount will be enabled).
