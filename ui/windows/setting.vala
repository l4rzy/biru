using Gtk;
namespace Biru.UI.Windows
{

class SettingWindow : Window {

	private Button btn_apply; 
	private Button btn_cancel; 

	public SettingWindow() {
		init_ui();

		btn_apply.clicked.connect (btn_apply_clicked);
		btn_cancel.clicked.connect (btn_cancel_clicked);
	}

	private void init_ui() {


		var stack = new Stack();
		stack.add_titled(new Button.with_label("Button 1"), "Button 1", "Button 1");
		stack.add_titled(new Button.with_label("Button 2"), "Button 2", "Button 2");

		btn_cancel = new Button.with_label("Cancel");

		btn_apply = new Button.with_label("Apply");

		var stack_switcher = new StackSwitcher();
		stack_switcher.stack = stack;
		stack_switcher.halign = Gtk.Align.CENTER;


		var header_bar = new HeaderBar();
		header_bar.pack_start(btn_cancel);
		header_bar.pack_end(btn_apply);

		var vbox = new Box(Gtk.Orientation.VERTICAL, 0);
		vbox.add(stack_switcher);
		vbox.add(stack);

		set_titlebar(header_bar);
		add(vbox);
		set_default_size(480, 680);
		show_all ();
	}

	private void btn_apply_clicked() {
		close ();
		apply_changes();
	}

	private void btn_cancel_clicked() {
		close ();
	}

	private void apply_changes() {
		
	}
}
}
