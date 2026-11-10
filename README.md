# Epeira

AGNoStep Apps
(c) 2026 - Patrick Cardona

Thanks for the GNUstep Developers Community.
This is Free and Open Source software.
Read [LICENSE](./LICENSE) in the root directory.

# What is Epeira?

This is a GNUstep Web Browser and Service. Its name comes from a latin  
word to name a common spider species.

The Web window is an X embedded Surf browser, which provides a complete  
**Gtk-WebKit Engine**. It is displayed within the GNUstep application thanks   
to a Helper:  `epeira_socket`.

The **favorites** are handled with **Internet Shortcuts**, i.e. '*.url' in the  
home `Favorites` folder. The code of this  
part was derived from previous `SaveLink.app`.

Default **Web search** is performed with **Duckduckgo** by default.

A minimal **History** is also provided: back and forward.

**Bookmarking** the current page is provided by a save url Panel.

**Password management** will be provided with a service from the  
new `Pass.app` (to be done).

# Dependencies

**Epeira** depends on:
- A complete **GNUstep System**:  
see [Agnostep Desktop](https://github.com/pcardona34/agnostep-desktop).
- **Renaissance** framework.
- **Surf** browser provided by [Suckless dot Org](https://suckless.org/Surf).
- `HelpViewer.app` to display the Help content.
- New `Pass.app` release to get the **password management**  
service (to be done).

# Install

You must have superuser privileges to type your password
when asked.

Execute:

```console
bash ./install.sh
```

This will fetch dependencies (until now, only on Debian Trixie), install Scripts  
and Conf, build and install the Helper and the Web Browser.

# Using

```console
openapp Epeira
```

Or run it from the `Applications` folder.

# Using the Service

- Select an URL;
- From the menu, do: `Services/Open URL with Epeira`.

# Help

Help is provided from `Info/Help...` menu.
