# source code from https://stackoverflow.com/questions/39353073/how-i-can-send-mouse-click-in-powershell
$cSource = @'
using System;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;
public class Clicker
{
  //https://msdn.microsoft.com/en-us/library/windows/desktop/ms646270(v=vs.85).aspx
  [StructLayout(LayoutKind.Sequential)]
  struct INPUT
  {
    public int        type; // 0 = INPUT_MOUSE,
                            // 1 = INPUT_KEYBOARD
                            // 2 = INPUT_HARDWARE
    public MOUSEINPUT mi;
  }

  //https://msdn.microsoft.com/en-us/library/windows/desktop/ms646273(v=vs.85).aspx
  [StructLayout(LayoutKind.Sequential)]
  struct MOUSEINPUT
  {
    public int    dx ;
    public int    dy ;
    public int    mouseData ;
    public int    dwFlags;
    public int    time;
    public IntPtr dwExtraInfo;
  }

  //This covers most use cases although complex mice may have additional buttons
  //There are additional constants you can use for those cases, see the msdn page
  const int MOUSEEVENTF_MOVED      = 0x0001 ;
  const int MOUSEEVENTF_LEFTDOWN   = 0x0002 ;
  const int MOUSEEVENTF_LEFTUP     = 0x0004 ;
  const int MOUSEEVENTF_RIGHTDOWN  = 0x0008 ;
  const int MOUSEEVENTF_RIGHTUP    = 0x0010 ;
  const int MOUSEEVENTF_MIDDLEDOWN = 0x0020 ;
  const int MOUSEEVENTF_MIDDLEUP   = 0x0040 ;
  const int MOUSEEVENTF_WHEEL      = 0x0080 ;
  const int MOUSEEVENTF_XDOWN      = 0x0100 ;
  const int MOUSEEVENTF_XUP        = 0x0200 ;
  const int MOUSEEVENTF_ABSOLUTE   = 0x8000 ;

  const int screen_length = 0x10000 ;

  //https://msdn.microsoft.com/en-us/library/windows/desktop/ms646310(v=vs.85).aspx
  [System.Runtime.InteropServices.DllImport("user32.dll")]
  extern static uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

  [System.Runtime.InteropServices.DllImport("user32.dll")]
  static extern void mouse_event(int dwFlags, int dx, int dy, int dwData, int dwExtraInfo);

  public static void MoveToPoint(int x, int y)
  {
    //Move the mouse
    INPUT[] input = new INPUT[1];
    input[0].mi.dx = x*(65535/System.Windows.Forms.Screen.PrimaryScreen.Bounds.Width);
    input[0].mi.dy = y*(65535/System.Windows.Forms.Screen.PrimaryScreen.Bounds.Height);
    input[0].mi.dwFlags = MOUSEEVENTF_MOVED | MOUSEEVENTF_ABSOLUTE;
    SendInput(1, input, Marshal.SizeOf(input[0]));
  }

  public static void LeftClick()
  {
    //click left mouse button
    INPUT[] input = new INPUT[2];
    //Left mouse button down
    input[0].mi.dwFlags = MOUSEEVENTF_LEFTDOWN;
    //Left mouse button up
    input[1].mi.dwFlags = MOUSEEVENTF_LEFTUP;
    SendInput(2, input, Marshal.SizeOf(input[0]));
  }

  public static void LeftDown()
  {
    INPUT[] input = new INPUT[1];
    //Left mouse button down
    input[0].mi.dwFlags = MOUSEEVENTF_LEFTDOWN;
    SendInput(1, input, Marshal.SizeOf(input[0]));
  }

  public static void LeftUp()
  {
    INPUT[] input = new INPUT[1];
    //Left mouse button up
    input[0].mi.dwFlags = MOUSEEVENTF_LEFTUP;
    SendInput(1, input, Marshal.SizeOf(input[0]));
  }

  public static void RightClick()
  {
    //Move the mouse
    INPUT[] input = new INPUT[2];
    //Right mouse button down
    input[0].mi.dwFlags = MOUSEEVENTF_RIGHTDOWN;
    //Right mouse button up
    input[1].mi.dwFlags = MOUSEEVENTF_RIGHTUP;
    SendInput(2, input, Marshal.SizeOf(input[0]));
  }

  public static void RightDown()
  {
    INPUT[] input = new INPUT[1];
    //Right mouse button down
    input[0].mi.dwFlags = MOUSEEVENTF_RIGHTDOWN;
    SendInput(1, input, Marshal.SizeOf(input[0]));
  }

  public static void RightUp()
  {
    INPUT[] input = new INPUT[1];
    //Right mouse button up
    input[0].mi.dwFlags = MOUSEEVENTF_RIGHTUP;
    SendInput(1, input, Marshal.SizeOf(input[0]));
  }

  public static void WheelDown()
  {
    int MOUSEEVENTF_WHEEL = 0x0800;
    mouse_event(MOUSEEVENTF_WHEEL, 0, 0, -120, 0);
  }

  public static void WheelUp()
  {
    int MOUSEEVENTF_WHEEL = 0x0800;
    mouse_event(MOUSEEVENTF_WHEEL, 0, 0, 120, 0);
  }

}
'@
Add-Type -TypeDefinition $cSource -ReferencedAssemblies System.Windows.Forms,System.Drawing
# Send a click at a specified point
#[Clicker]::LeftClickAtPoint(600,600)
