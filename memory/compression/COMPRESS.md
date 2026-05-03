# File Compression & Archiving — 压缩归档系统

> 系统版本: v4.0 | 用途: 旧文件压缩

## 支持格式

| 格式 | 工具 | 适用场景 |
|------|------|----------|
| .gz | gzip | 单文件快速压缩 |
| .zip | zip | 多文件打包 |
| .tar.gz | tar+gzip | 目录归档 |

---

## 📦 压缩策略

### 热文件压缩
```bash
# 30天以上的 accessed.txt 压缩
gzip -k hot/accessed.txt
```

### Session 日志压缩
```bash
# 90天以上的 session 压缩
tar -czf sessions/backups/sessions_2026_02.tar.gz sessions/*.md
```

---

## 🔧 压缩脚本

```python
# compress_old_files.py
import gzip
import os
from datetime import datetime, timedelta

MEMORY_DIR = "/root/.openclaw/workspace/memory"

def compress_if_old(filepath, days=90):
    """如果文件超过指定天数则压缩"""
    mtime = os.path.getmtime(filepath)
    age_days = (datetime.now().timestamp() - mtime) / 86400
    
    if age_days > days:
        with open(filepath, 'rb') as f:
            data = f.read()
        with gzip.open(f"{filepath}.gz", 'wb') as f:
            f.write(data)
        os.remove(filepath)
        print(f"✅ 压缩: {filepath}")
```

---

## 📂 归档目录结构

```
archive/
├── 2026/
│   ├── Q1/           # 2026年Q1归档
│   │   ├── daily_2026_01.md.gz
│   │   └── sessions_2026_01.tar.gz
│   └── Q2/           # 2026年Q2归档
│       └── ...
└── README.md         # 归档说明
```

---

## 🗂️ 恢复程序

```bash
# 解压单个文件
gunzip archive/2026/Q1/daily_2026_01.md.gz

# 解压目录
tar -xzf archive/2026/Q1/sessions_2026_01.tar.gz
```

---

*此文件由系统自动维护*