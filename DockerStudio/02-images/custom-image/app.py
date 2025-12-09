#!/usr/bin/env python3
import sys
import platform
from datetime import datetime

print("=" * 50)
print("🐳 Docker Python Application")
print("=" * 50)
print(f"Python Version: {platform.python_version()}")
print(f"Platform: {platform.platform()}")
print(f"Machine: {platform.machine()}")
print(f"Current Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
print("=" * 50)
print("✅ Application running successfully!")
