#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# ruff: noqa: E501

import sys

import gi
from gi.repository import Gimp, GLib

gi.require_version("Gimp", "3.0")
gi.require_version("GimpUi", "3.0")


class Plugin (Gimp.PlugIn):
    NEW_SIZE = 512
    NAME = "plug-in-py3-resize-512"
    BINARY = "py3-resize-512"
    MENU_PATH = "<Image>/⭐ _Plugins"
    MENU_LABEL = "Resize 512x512"

    def do_query_procedures(self):
        return [f"{self.NAME}-75", f"{self.NAME}-85", f"{self.NAME}-90", self.NAME]

    def do_create_procedure(self, name):
        if name == self.NAME:
            proc = Gimp.ImageProcedure.new(self, name, Gimp.PDBProcType.PLUGIN, self.run_proc, None)
            proc.set_sensitivity_mask(Gimp.ProcedureSensitivityMask.DRAWABLE | Gimp.ProcedureSensitivityMask.NO_DRAWABLES)
            proc.set_menu_label(self.MENU_LABEL)
            proc.add_menu_path(self.MENU_PATH)
            return proc
        if name == f"{self.NAME}-90":
            proc = Gimp.ImageProcedure.new(self, name, Gimp.PDBProcType.PLUGIN, self.run_proc_90, None)
            proc.set_sensitivity_mask(Gimp.ProcedureSensitivityMask.DRAWABLE | Gimp.ProcedureSensitivityMask.NO_DRAWABLES)
            proc.set_menu_label(f"{self.MENU_LABEL} 90%")
            proc.add_menu_path(self.MENU_PATH)
            return proc
        if name == f"{self.NAME}-85":
            proc = Gimp.ImageProcedure.new(self, name, Gimp.PDBProcType.PLUGIN, self.run_proc_85, None)
            proc.set_sensitivity_mask(Gimp.ProcedureSensitivityMask.DRAWABLE | Gimp.ProcedureSensitivityMask.NO_DRAWABLES)
            proc.set_menu_label(f"{self.MENU_LABEL} 85%")
            proc.add_menu_path(self.MENU_PATH)
            return proc
        if name == f"{self.NAME}-75":
            proc = Gimp.ImageProcedure.new(self, name, Gimp.PDBProcType.PLUGIN, self.run_proc_75, None)
            proc.set_sensitivity_mask(Gimp.ProcedureSensitivityMask.DRAWABLE | Gimp.ProcedureSensitivityMask.NO_DRAWABLES)
            proc.set_menu_label(f"{self.MENU_LABEL} 75%")
            proc.add_menu_path(self.MENU_PATH)
            return proc

        return None

    def run_proc(self, procedure, run_mode, image, drawables, config, data):
        # image = Gimp.get_images()[0]
        return self._extend_canvas(procedure, image, 512, 512)

    def run_proc_90(self, procedure, run_mode, image, drawables, config, data):
        return self._extend_canvas(procedure, image, 512, 512, 0.90)

    def run_proc_85(self, procedure, run_mode, image, drawables, config, data):
        return self._extend_canvas(procedure, image, 512, 512, 0.85)

    def run_proc_75(self, procedure, run_mode, image, drawables, config, data):
        return self._extend_canvas(procedure, image, 512, 512, 0.75)

    def _extend_canvas(self, procedure, image, new_width, new_height, scale=1.0):
        image.undo_group_start()

        image.autocrop()

        w = image.get_width()
        h = image.get_height()

        target_w = new_width
        target_h = new_height

        if scale < 1.0:
            target_w = int(w * scale)
            target_h = int(h * scale)

        # scale down if larger
        if w > target_w or h > target_h:
            scale_factor = min(target_w / w, target_h / h)
            new_w = int(w * scale_factor)
            new_h = int(h * scale_factor)
            image.scale(new_w, new_h)
            w, h = new_w, new_h

        offset_x = (new_width - w) // 2
        offset_y = (new_height - h) // 2

        image.resize(new_width, new_height, offset_x, offset_y)

        image.undo_group_end()

        return procedure.new_return_values(Gimp.PDBStatusType.SUCCESS, None)

    def _error(self, procedure, message):
        message = f"ERROR: {message}"
        return procedure.new_return_values(Gimp.PDBStatusType.CALLING_ERROR, GLib.Error(message))


Gimp.main(Plugin.__gtype__, sys.argv)
