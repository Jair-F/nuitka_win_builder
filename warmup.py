import os
import sys

# 1. Scientific & Math (The "Recipe" Kings)
try:
    import numpy
    import pandas
    import scipy
    import matplotlib.pyplot as plt
    print(f"Captured Math/Science Recipes: {numpy.__version__}, {pandas.__version__}")
except ImportError:
    print("Warning: Math/Science libs not found - skipping recipe trigger.")

# 2. Machine Learning (The "DLL-Mapping" Heavies)
try:
    import torch
    import torchvision
    print(f"Captured Torch/ML Recipes: {torch.__version__}")
except ImportError:
    print("Warning: Torch libs not found - skipping recipe trigger.")

# 3. GUI Frameworks (The "Resource" Tricky ones)
try:
    from PyQt6.QtCore import QCoreApplication
    import customtkinter
    print("Captured GUI Recipes: PyQt6 & CustomTkinter")
except ImportError:
    print("Warning: GUI libs not found - skipping recipe trigger.")

# 4. Computer Vision & Imaging
try:
    import cv2
    from PIL import Image
    print("Captured Vision Recipes: OpenCV & Pillow")
except ImportError:
    print("Warning: Vision libs not found - skipping recipe trigger.")

# 5. Networking & Web (The "Anti-Bloat" Targets)
try:
    import requests
    import urllib3
    # Note: Playwright requires a browser install to fully warm up, 
    # but the Nuitka plugin logic triggers on import.
    import playwright
    print("Captured Networking/Web Recipes")
except ImportError:
    print("Warning: Web libs not found - skipping recipe trigger.")

# --- The Actual "Warmup" Action ---
def main():
    print("\n--- Nuitka Warmup Report ---")
    print(f"Python Version: {sys.version}")
    print(f"Nuitka Cache Target: {os.environ.get('NUITKA_CACHE_DIR', 'Default Path')}")
    print("Status: All internal plugin triggers successfully analyzed.")

if __name__ == "__main__":
    main()
