using Godot;

public static class Vector3Extension 
{
    public static Vector3 ClampMag(this Vector3 v, float maxlen)
    {
        if (v.Length() > maxlen)
        {
            return v.Normalized() * maxlen;
        }
        return v;
    }
}