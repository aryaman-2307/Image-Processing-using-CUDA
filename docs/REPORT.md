
---

### **docs/REPORT.md**

```markdown
# GPU Median Filter on Batch Images

## 1 Motivation
Bulk cleaning / de‑noising of scanned texture archives …

## 2 Dataset
155 greyscale PNGs from USC‑SIPI “Textures” (public domain).

## 3 Implementation
* **NPP** kernel `nppiFilterMedian_8u_C1R`
* Host‑side tiling handled by NPP; border excluded via ROI
* CLI & file I/O with STB

## 4 Results
> Hardware: i7‑12700H + RTX 3060 (6 GB), CUDA 12.4, driver 555.**

| Step | Time (CPU OpenCV) | Time (GPU NPP) | Speed‑up |
|------|------------------:|---------------:|---------:|
| 155×512² median | 5.2 s | **0.18 s** | 29× |

Full log & NV‑Nsight summary in `execution-artifacts/`.

## 5 Lessons
* At 512 × 512 the memcpy H2D/D2H overhead is negligible
* JPEG/PNG decode becomes the bottleneck for < 1 MP frames
* Future: stream 4 K video frames and overlap decode ↔ kernel

