[GtkTemplate(ui = "/com/github/sleeeee/sietch/ui/clock.ui")]
public class Clock : Gtk.Box {
  private uint timeout;

  [GtkChild]
  private unowned Gtk.Label hours;
  [GtkChild]
  private unowned Gtk.Label minutes;
  [GtkChild]
  private unowned Gtk.Popover clock_popover;

  [GtkCallback]
  public void toggle_popover() {
    this.clock_popover.popup();
  }

  private void update_clock_labels() {
    GLib.DateTime now = new GLib.DateTime.now_local();
    this.hours.label = now.format("%H");
    this.minutes.label = now.format("%M");
  }

  class construct {
    set_css_name("clock");
  }

  construct {
    this.timeout = GLib.Timeout.add(10000, () => {
      this.update_clock_labels();
      return GLib.Source.CONTINUE;
    });
    this.update_clock_labels();
  }

  public override void dispose() {
    GLib.Source.remove(this.timeout);
    this.timeout = 0;
    base.dispose();
  }
}
