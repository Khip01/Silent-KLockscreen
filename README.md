# Silent KLockscreen Port (Plasma 6)

This project is a manual visual port of the beautiful [SilentSDDM](https://github.com/uiriansan/SilentSDDM) theme by [@uiriansan](https://github.com/uiriansan), specifically modified to work with the native **KDE Plasma 6 Lockscreen** (kscreenlocker).

> [!CAUTION]
> **USE AT YOUR OWN RISK.** This project modifies critical system files in `/usr/share/plasma/`. I am not responsible for any broken systems, black screens, or if you get locked out of your desktop. Always ensure you have a terminal (TTY) or SSH access before proceeding. **Read the "How to Test" section carefully!**

---

## Visual Proof-of-Concept

| Original Plasma 6                                                      | Ported Silent Look                                           |
| ---------------------------------------------------------------------- | ------------------------------------------------------------ |
| ![Original](https://i.ibb.co.com/Zz339NBY/KLock-Screen-Original-1.png) | ![Mod](https://i.ibb.co.com/gZG3vrtF/KLock-Screen-Mod-1.png) |
| ![Original](https://i.ibb.co.com/1f1PMtvZ/KLock-Screen-Original-2.png) | ![Mod](https://i.ibb.co.com/DDNxJZRN/KLock-Screen-Mod-2.png) |

---

## Features & Limitations

- **Aesthetic:** Ported components (Input, Avatar, Spinner) and typography (RedHatDisplay).
- **API Mapping:** Adapted SDDM login logic to work with Plasma's `Authenticator` API.
- **Static Layout:** Currently supports only the **Center Layout**. Dynamic positioning (Left/Right) via `.conf` files is not yet implemented due to Plasma's rigid shell constraints.
- **Visual Skin:** This is primarily a component-level "skin" over the existing `kscreenlocker` behavior.

---

## Wallpaper Configuration

Since this is a port for the native Plasma lockscreen, the wallpaper is managed by KDE Plasma's system settings, not the theme's `.conf` file.

1. Go to **System Settings** -> **Screen Locking**.
2. Click **Appearance** (Configure...).
3. Select your preferred wallpaper.

### Using Video Wallpapers (Recommended)

To achieve the animated background look (MP4/WebM) as seen in some SilentSDDM previews:

- I use the **"Smart Video Wallpaper Reborn"** plugin.
- You can install it via the "Get New Plugins" button in the Wallpaper configuration window.
- It works perfectly with this ported layout!

---

## Installation

1. **Clone this repository:**

   ```bash
   git clone https://github.com/Khip01/Silent-KLockscreen.git
   cd Silent-KLockscreen
   ```

2. **Run the installer:**
   The script will automatically create a backup of your original lockscreen files at `/usr/share/plasma/shells/org.kde.plasma.desktop/contents/lockscreen.bak`.
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

---

## How to Test Safely (DO THIS FIRST!)

**DO NOT** press `Meta+L` immediately after installation. Run the following command to see a preview of the lockscreen in a window:

```bash
/usr/lib64/libexec/kscreenlocker_greet --testing
```

> [!NOTE]
> _The path might vary by distribution. If not found, try searching for the `kscreenlocker_greet` binary._

**If the window opens and looks correct**, you are safe to lock your screen (Press `Meta+L`). If it crashes or shows a "broken QML" message, run the recovery script immediately.

---

## Recovery

If something goes wrong or you want to go back to the default Plasma look:

```bash
chmod +x uninstall.sh
./uninstall.sh
```

---

## Credits

- **Original Artwork & Design:** All credit goes to [uiriansan](https://github.com/uiriansan), the creator of SilentSDDM.
- **Porting:** Ported to Plasma 6 by [Khip01](https://github.com/Khip01)/me to bridge the visual gap between SDDM and the KDE Lockscreen.
- **License:** Distributed under the same license as the original project (GPL-3.0).

---

## Technical Details (For Developers)

- **Target Path:** `/usr/share/plasma/shells/org.kde.plasma.desktop/contents/lockscreen`
- **Logic:** Replaced `sddm.login()` with `authenticator.respond(password)`.
- **Styling:** Uses a `SilentConfig.qml` singleton to manage theme variables without a native SDDM theme engine.
