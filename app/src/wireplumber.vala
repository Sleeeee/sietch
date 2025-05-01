[GtkTemplate(ui = "/com/github/sleeeee/sietch/ui/wireplumber.ui")]
public class Wireplumber : Gtk.Box {
  public AstalWp.Endpoint speaker { get; private set; }
  
  [GtkChild]
  private unowned CircularProgress wireplumber_progress;
  [GtkChild]
  private unowned Gtk.Image wireplumber_icon;
  [GtkChild]
  private unowned Gtk.Popover wireplumber_popover;
  [GtkChild]
  private unowned Gtk.GestureClick left_click;
  [GtkChild]
  private unowned Gtk.GestureClick right_click;

  [GtkCallback]
  public void toggle_mute() {
    this.speaker.mute = !this.speaker.mute;
  }

  [GtkCallback]
  public void toggle_popover() {
    this.wireplumber_popover.popup();
  }

  [GtkCallback]
  public bool increment_volume(double dx, double dy) {
    this.speaker.volume -= 0.05 * dy;
    return Gdk.EVENT_STOP;
  }

  private void set_mute_class(bool is_mute) {
    if (is_mute) {
      if (!this.wireplumber_progress.has_css_class("warning")) { this.wireplumber_progress.add_css_class("warning"); }
      if (!this.wireplumber_icon.has_css_class("warning")) { this.wireplumber_icon.add_css_class("warning"); }
    } else {
      if (this.wireplumber_progress.has_css_class("warning")) { this.wireplumber_progress.remove_css_class("warning"); }
      if (this.wireplumber_icon.has_css_class("warning")) { this.wireplumber_icon.remove_css_class("warning"); }
    }
  }

  construct {
    this.speaker = AstalWp.get_default().default_speaker;
    this.speaker.notify["mute"].connect(() => { set_mute_class(this.speaker.mute); });
    set_mute_class(this.speaker.mute);
    this.left_click.set_button(Gdk.BUTTON_PRIMARY);
    this.right_click.set_button(Gdk.BUTTON_SECONDARY);
  }
}
