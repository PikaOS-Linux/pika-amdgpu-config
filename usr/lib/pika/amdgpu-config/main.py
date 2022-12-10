import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk
import subprocess
import os

class Application:
    
    ### MAIN WINDOW ###
    def __init__(self):
        
        self.column_names = False
        self.drop_nan = False
        self.df = None
        
        self.builder = Gtk.Builder()
        self.builder.add_from_file("/usr/lib/pika/amdgpu-config/main.ui")
        self.builder.connect_signals(self)
        win = self.builder.get_object("window")
        win.connect("destroy", Gtk.main_quit)
        
        self.window = self.builder.get_object("window")
        self.window.show()
        
    def on_install_pressed(self, widget):
        self.builder.get_object("window").hide()
        os.system("/usr/lib/pika/amdgpu-config/amdgpu-modify.sh")
        self.builder.get_object("window").close()
        self.builder.get_object("window").destroy()
        
    def on_remove_pressed(self, widget):
        self.builder.get_object("window").hide()
        os.system("/usr/lib/pika/amdgpu-config/amdgpu-remove.sh")
        self.builder.get_object("window").close()
        self.builder.get_object("window").destroy()
        
    
Application()
Gtk.main()
