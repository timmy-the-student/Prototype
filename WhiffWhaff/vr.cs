using Godot;
using System;

public partial class vr : Node3D
{
	
	private XRInterface _xrInterface;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		_xrInterface = XRServer.FindInterface("OpenXR");
		if(_xrInterface != null && _xrInterface.IsInitialized())
		{
			DisplayServer.WindowSetVsyncMode(DisplayServer.VSyncMode.Disabled);
			GetViewport().UseXR = true;
		} else {
			GetViewport().UseXR = false;
		}
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
