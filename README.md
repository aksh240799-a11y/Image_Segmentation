# 🐟 Isolating a Camouflaged Flatfish Using Image Segmentation in MATLAB

A hands-on image segmentation project completed as part of the **MathWorks MATLAB course: *Postprocessing to Improve Segmentation***.

The goal is to isolate a flatfish camouflaged against a sandy background using a series of image processing and morphological operations in MATLAB.

---

## 📷 Project Overview

Flatfish are masters of camouflage — their texture and color blend seamlessly into sandy ocean floors, making segmentation a non-trivial problem. This project demonstrates how standard filtering, binarization, and morphological postprocessing can successfully isolate the fish from its background.

---

## 🧰 Tools & Functions Used

| MATLAB Function | Purpose |
|---|---|
| `imread` | Read image from file |
| `im2gray` | Convert RGB to grayscale |
| `stdfilt` | Standard deviation filtering to highlight texture |
| `rescale` | Normalize pixel values to [0, 1] |
| `medfilt2` | Median filtering to reduce noise |
| `imbinarize` | Convert grayscale to binary image |
| `imcomplement` | Invert binary image (swap foreground/background) |
| `imfill` | Fill holes in foreground objects |
| `bwareafilt` | Keep only the largest connected region |
| `strel` | Create structuring element for morphology |
| `imopen` | Morphological opening (erosion → dilation) |
| `imclose` | Morphological closing (dilation → erosion) |

---

## 🔬 Step-by-Step Pipeline

### 🔹 Preprocessing

```matlab
flatFish = imread("flatfish.jpg");
fishGray = im2gray(flatFish);
fishSTD = stdfilt(fishGray);
fishSTD = rescale(fishSTD);
fishSTD = medfilt2(fishSTD, [7 7]);
fishBW = imbinarize(fishSTD);
imshowpair(flatFish, fishBW, "montage")
```

- The RGB image is converted to **grayscale**.
- **Standard deviation filtering** (`stdfilt`) highlights regions of high texture variation — the fish body has more texture variation than the uniform sand.
- The result is **rescaled** to [0, 1] for consistent binarization.
- **Median filtering** with a 7×7 kernel smooths out noise while preserving edges.
- **Binarization** (`imbinarize`) converts the image to black and white using an automatic threshold.

---

### 🔹 Task 1 — Invert the Binary Image

```matlab
fishBW = imcomplement(fishBW);
imshow(fishBW)
```

After binarization, the fish appears as the **background** (black) rather than the foreground (white). `imcomplement` inverts the image so the fish becomes the **white foreground object**, which is the convention expected by MATLAB's binary image postprocessing functions.

---

### 🔹 Task 2 — Fill Holes and Isolate the Fish

```matlab
fishBW = imfill(fishBW, "holes");
imshow(fishBW)

fishBW = bwareafilt(fishBW, 1);
imshow(fishBW)
```

- `imfill` fills enclosed dark regions (holes) within the white foreground object, resulting in a more solid fish mask.
- `bwareafilt(fishBW, 1)` keeps only the **single largest connected component** — which corresponds to the fish — effectively discarding all noisy pixel clusters around the border and background.

---

### 🔹 Task 3 — Remove Protruding Pixels (Morphological Opening)

```matlab
SE = strel("disk", 5);
fishBW = imopen(fishBW, SE);
imshow(fishBW)
```

- A **disk-shaped structuring element** of radius 5 is created using `strel`. This acts as a sliding window for morphological operations.
- `imopen` performs **erosion followed by dilation**:
  - **Erosion** shaves away small protrusions and thin outgrowths at the boundary.
  - **Dilation** restores the main body of the object to roughly its original size.
- The net effect is the removal of unwanted protruding pixels while preserving the core fish shape.

---

### 🔹 Task 4 — Smooth the Edges (Morphological Closing)

```matlab
SE = strel("disk", 5);
fishBW = imclose(fishBW, SE);
imshow(fishBW)
```

- `imclose` performs **dilation followed by erosion**:
  - **Dilation** first bridges small gaps and indentations along the boundary.
  - **Erosion** then restores the object size.
- The net effect is **smoother, cleaner edges** on the segmented fish mask.

> **Opening vs Closing — Quick Reference:**
> | Operation | Order | Effect |
> |---|---|---|
> | `imopen` | Erosion → Dilation | Removes small protrusions, cleans outer boundary |
> | `imclose` | Dilation → Erosion | Fills small gaps, smooths inner boundary |

---
## 📊 Visual Results

| Stage | Description | Result |
|---|---|---|
| Preprocessing | Raw image + initial binary mask | <img src="https://github.com/user-attachments/assets/66758da2-5a41-43aa-9580-f556f4b56f03" width="300"/> |
| Task 1 | After `imcomplement` — fish becomes white foreground | <img src="https://github.com/user-attachments/assets/be6d08f0-6c2a-4a8c-a2e4-4ba39a169a5a" width="300"/> |
| Task 2a | After `imfill` — holes filled | <img src="https://github.com/user-attachments/assets/776fe5f0-9732-404e-acc8-5939cb922cde" width="300"/> |
| Task 2b | After `bwareafilt` — fish isolated | <img src="https://github.com/user-attachments/assets/e8185ea6-c58f-4e96-985b-e17ffd1a88e4" width="300"/> |
| Task 3 | After `imopen` — protrusions removed | <img src="https://github.com/user-attachments/assets/51d964ed-71e7-4744-858e-63377cfd9120" width="300"/> |
| Task 4 | After `imclose` — edges smoothed | <img src="https://github.com/user-attachments/assets/7f9c9cbe-2c1f-4369-8a2b-009a01528ee2" width="300"/> |

```
## 📁 File Structure

```
├── fish_segmentation.m   # Main MATLAB script
└── README.md             # Project documentation
```

---

## 🎓 Course Reference

- **Platform:** MathWorks MATLAB OnRamp / Image Processing Track  
- **Course:** *Postprocessing to Improve Segmentation*  


---

## 👤 Author

**Akshaya Ananthakrishnan**  
MATLAB Certified | Image Processing Enthusiast

