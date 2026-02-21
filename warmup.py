import sys

def trigger(name, func):
    try:
        func()
        print(f"✅ Cached: {name}")
    except ImportError:
        print(f"❌ Skipped: {name} (Not installed)")

# --- Project Specific Imports ---
trigger("Windows API", lambda: (__import__('win32api'), __import__('winotify')))
trigger("Data/Config", lambda: (__import__('box'), __import__('yaml')))
trigger("Shortcuts", lambda: __import__('pyshortcuts'))

# --- Big Library Imports (The "Problematic" ones) ---
trigger("Scientific", lambda: (__import__('numpy'), __import__('pandas'), __import__('scipy')))
# trigger("Machine Learning", lambda: (__import__('torch'), __import__('torchvision')))
trigger("GUI", lambda: (__import__('PyQt6.QtCore', fromlist=['Qt']), __import__('customtkinter')))
# trigger("Vision", lambda: (__import__('cv2'), __import__('PIL.Image')))
trigger("Web", lambda: (__import__('requests'), __import__('playwright')))
trigger("Serialize", lambda: (__import__('pickle')))

if __name__ == "__main__":
    print(f"\nWarmup complete for Python {sys.version}")
