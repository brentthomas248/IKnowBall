#!/usr/bin/env python3
"""
Generate all required iOS app icon sizes from master 1024x1024 icon.
"""

from PIL import Image
import os
import sys

def resize_icon(input_path, output_dir, sizes):
    """Resize icon to all required iOS sizes."""
    try:
        # Open the master icon
        img = Image.open(input_path)
        
        # Verify it's 1024x1024
        if img.size != (1024, 1024):
            print(f"Warning: Input image is {img.size}, expected (1024, 1024)")
        
        # Create output directory if needed
        os.makedirs(output_dir, exist_ok=True)
        
        # Generate each size
        for size, filename in sizes.items():
            resized = img.resize((size, size), Image.Resampling.LANCZOS)
            output_path = os.path.join(output_dir, filename)
            resized.save(output_path, 'PNG')
            print(f"✓ Created {filename} ({size}x{size})")
        
        print(f"\n✓ Successfully generated {len(sizes)} icon sizes")
        return True
        
    except Exception as e:
        print(f"✗ Error: {e}")
        return False

if __name__ == "__main__":
    # Define all required iOS icon sizes
    ICON_SIZES = {
        1024: "icon_1024.png",      # App Store
        180: "icon_180.png",         # iPhone 3x @60pt
        120: "icon_120.png",         # iPhone 2x @60pt
        80: "icon_80.png",           # iPad 2x @40pt / Spotlight
        60: "icon_60.png",           # iPad 1x @60pt
        40: "icon_40.png",           # Notification 2x @20pt
    }
    
    if len(sys.argv) < 2:
        print("Usage: python3 resize_icons.py <master_icon_path>")
        sys.exit(1)
    
    input_path = os.path.abspath(sys.argv[1])
    output_dir = os.path.dirname(input_path)
    
    print(f"Resizing icon: {input_path}")
    print(f"Output directory: {output_dir}\n")
    
    success = resize_icon(input_path, output_dir, ICON_SIZES)
    sys.exit(0 if success else 1)
