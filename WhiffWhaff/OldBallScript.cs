using Godot;
using System;

public partial class Ball : RigidBody3D
{
	public RigidBody3D ball;
	public XRController3D offhand;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		ball = GetNode<RigidBody3D>("Ball");
		offhand = GetNode<XRController3D>("player/XROrigin3D/offhand");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if(Input.IsActionPressed("grip_click") && Mathf.Abs((offhand.Position - ball.Position).Length()) < 0.1f){
			Freeze = true;
		} else {
			Freeze = false;
		}
	}
}
