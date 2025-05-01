public class Application : Astal.Application {
  public static Application instance;

  public override void activate() {
    base.activate();

    Gtk.CssProvider css_provider = new Gtk.CssProvider();
    css_provider.load_from_resource("com/github/sleeeee/sietch/style.css");
    Gtk.StyleContext.add_provider_for_display(
      Gdk.Display.get_default(),
      css_provider,
      Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
    );

    var monitors = Gdk.Display.get_default().get_monitors();
    for (var i = 0; i <= monitors.get_n_items(); ++i) {
      var m = (Gdk.Monitor)monitors.get_item(i);
      if (m != null) {
        var bar = new Bar(m);
        bar.present();
        m.invalidate.connect(() => bar.destroy());
      }
    }
    monitors.items_changed.connect((p, r, a) => {
      Gdk.Display.get_default().sync();
      for (; a > 0; a--) {
        var m = (Gdk.Monitor)monitors.get_item(p++);
        var bar = new Bar(m);
        bar.present();
        m.invalidate.connect(() => bar.destroy());
      }
    });

    this.hold();
  }

  construct {
    instance = this;
  }
}
