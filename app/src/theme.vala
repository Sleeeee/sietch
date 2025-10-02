[GtkTemplate(ui = "/com/github/sleeeee/sietch/ui/theme.ui")]
public class Theme : Gtk.Box {
  public Brightness brightness { get; private set; }

  private struct ThemeConfig {
    string theme;
    string variant;
  }

  private const string CONFIG_DIR = "/.config";
  private const string ALACRITTY_CONFIG = CONFIG_DIR + "/alacritty/alacritty.toml";
  private const string THEME_CONFIG = CONFIG_DIR + "/theme";
  private const string HYPR_DIR = CONFIG_DIR + "/hypr";

  private string get_config_path(string path) {
    return GLib.Environment.get_home_dir() + path;
  }

  [GtkChild]
  private unowned CircularProgress brightness_progress;
  [GtkChild]
  private unowned Gtk.Popover theme_popover;

  [GtkCallback]
  public void toggle_popover() {
    this.theme_popover.popup();
  }

  [GtkCallback]
  public bool increment_brightness(double dx, double dy) {
    this.brightness.brightness -= 0.05 * dy;
    return Gdk.EVENT_STOP;
  }

  private ThemeConfig parse_theme_config(string button_name) throws Error {
    string[] parts = button_name.split(":");
    if (parts.length != 2) { throw new IOError.INVALID_ARGUMENT("Invalid theme config format"); }
    return ThemeConfig() { theme = parts[0], variant = parts[1] };
  }

  private string read_file_contents(string path) throws Error {
    uint8[] contents;
    GLib.File file = GLib.File.new_for_path(path);
    file.load_contents(null, out contents, null);
    return (string)contents;
  }

  private void replace_file_contents(string path, string contents) throws Error {
    GLib.File file = GLib.File.new_for_path(path);
    file.replace_contents(contents.data, null, false, GLib.FileCreateFlags.NONE, null, null);
  }

  private void update_alacritty_theme(string theme, string variant) throws Error {
    string alacritty_path = get_config_path(ALACRITTY_CONFIG);
    string alacritty_contents = read_file_contents(alacritty_path);

    GLib.Regex regex = new GLib.Regex("(import\\s*=\\s*\\[\"~/.config/alacritty/themes/)(.+)-([^-]+)(\\.toml\"\\])");
    alacritty_contents = regex.replace(alacritty_contents, -1, 0, "\\1%s-%s\\4".printf(theme, variant));

    replace_file_contents(alacritty_path, alacritty_contents);
  }

  private void update_theme_config(string theme, string variant) throws Error {
    replace_file_contents(get_config_path(THEME_CONFIG), "%s:%s".printf(theme, variant));
  }

  private void refresh_hyprpaper(string theme, string variant) {
    Pid pid;
    GLib.Process.spawn_async(get_config_path(HYPR_DIR), {"./theme.sh"}, null, GLib.SpawnFlags.SEARCH_PATH, null, out pid);
  }

  [GtkCallback]
  public void set_theme(Gtk.Button button) {
    try {
      ThemeConfig theme_config = parse_theme_config(button.get_name());
      update_alacritty_theme(theme_config.theme, theme_config.variant);
      update_theme_config(theme_config.theme, theme_config.variant);
      refresh_hyprpaper(theme_config.theme, theme_config.variant);

    } catch (Error e) {
      critical("%s\n", e.message);
    }
  }

  construct {
    this.brightness = new Brightness();
  }
}
