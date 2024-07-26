# Understanding Video Cameras: a Simple Guide for Behavior Scientists

> **Leonardo Restivo** and  **llama 3.1**<sup>[1]</sup>
> _NeuroBAU, Department of Fundamental Neurosciences, Faculty of Biology & Medicine, University of Lausanne - Switzerland_

At its core, a video camera consists of three primary components: the **lens**, **sensor**, and **processing unit**. The lens is responsible for focusing light onto the image sensor. The image sensor converts the focused light into electrical signals that are then processed by the camera's electronics. The processing unit is responsible for converting the raw image data from the sensor into a digital video signal. This involves tasks such as demosaicing (converting color information), white balancing, and applying noise reduction algorithms. We won’t go any further into the types of processing units. This guide is focused on sensors, lenses and their features.

When selecting a camera for scientific purposes, consider first and foremost the imaging system’s purpose – i.e. what you need to acquire (region of interest, size of the subject, speed of moving objects) and in what environmental conditions the video will be acquired (low-light).
This guide is intended as a support to better understand the different components of an imagining system and how these affect the quality of the videos to be acquired.

## 1. The Sensor
In this chapter, we introduce the fundamental characteristics of image sensors. By gaining a deeper understanding of the sensors and its features, we can make informed decisions about camera selection and optimization for specific applications.
- Types of Image Sensors
- - Charge-Coupled Devices (CCDs)
- - Complementary Metal-Oxide-Semiconductor (CMOS) sensors
- Pixel Characteristics
- - Pixel size
- - Full Well Capacity (FWC)
- - Dark Current
- - Read Noise
- Sensor Size
- Pixel Pitch and Interpixel Distance
- Sensitivity and Dynamic Range
- Image Sensor Technologies for Specific Applications
- - High-speed sensors
- - Low-light sensitivity sensors 
- - Infrared-sensitive sensors for thermal imaging

### Types of Image Sensors

#### Charge-Coupled Device (CCD)
A CCD is an analog device that converts light into electrical signals. It consists of a matrix of photodiodes, amplifiers, and capacitors.
##### Advantages:
- **High Sensitivity**: CCDs are highly sensitive to low-light levels due to their ability to amplify the signal.
- **Low Noise**: CCDs have lower noise levels compared to CMOS sensors, making them suitable for applications where high-quality images are required.
- **Good Dynamic Range**: CCDs can capture a wide range of light intensities (dynamic range) without losing detail or introducing artifacts.

##### Disadvantages:
- **Power Consumption**: CCDs consume more power than CMOS sensors due to the need for amplification and analog-to-digital conversion.
- **Complexity**: CCDs are more complex devices, requiring additional components like clock drivers and amplifiers.
- **Expensive**: High-quality CCDs can be expensive compared to CMOS sensors.

#### Complementary Metal-Oxide-Semiconductor (CMOS)
A CMOS is a digital device that converts light into electrical signals using complementary MOS transistors.

##### Advantages:
- Low Power Consumption: CMOS sensors consume significantly less power than CCDs, making them suitable for battery-powered devices or applications where energy efficiency is crucial.
- Simple Architecture: CMOS sensors have a simpler architecture compared to CCDs, reducing the need for amplifiers and analog-to-digital converters.
- Cost-Effective: CMOS sensors are generally more affordable than high-quality CCDs.

##### Disadvantages:
- Noise Sensitivity: CMOS sensors can be more prone to noise due to their digital nature and the presence of electronic components like row-column decoders.
- Limited Dynamic Range: CMOS sensors may struggle with capturing a wide range of light intensities (dynamic range) without introducing artifacts or losing detail.


### Pixel characteristics
Pixel size refers to the physical dimensions of a single image sensor element (e.g., photodiode or photosite). It's measured in micrometers (μm) and represents the smallest unit of light-sensitive area on an image sensor.

> **Pixel size** usually ranges between small (1.12 - 3.6 μm), medium (2 - 6.7 μm), and large (3.8 – 14.4 μm).

#### Full Well Capacity (FWC)
FWC refers to the maximum amount of charge that can be stored in each pixel before it becomes saturated and loses its ability to accurately capture light information. In an image sensor, when a pixel reaches its FWC, it becomes "saturated" and can no longer accurately capture light information. This means that if you're trying to capture a bright scene with high-contrast details, the saturated pixels might lose their ability to distinguish between different brightness levels, resulting in lost detail or even artifacts.

#### Dark current
Dark Current refers to the spontaneous flow of electrons that occurs even when no light is present. This phenomenon is inherent to the sensor's material properties and can't be completely eliminated. Dark Current has significant implications for video acquisition: as each frame is captured and processed, dark current contributes to a cumulative noise (noise accumulation) effect that can become noticeable over time. Dark current also introduces temporal noise patterns in the image stream, which can be particularly problematic when capturing high-frame-rate or slow-motion footage.

#### Read noise
Read Noise refers to the random fluctuations in pixel values that occur during the process of reading out the sensor's charge storage elements (e.g., capacitors or wells). This phenomenon is inherent to the sensor's architecture and can't be completely eliminated.

### Sensor Size
The sensor size refers to the physical dimensions of the image sensor. A larger sensor size typically means a higher quality camera with better low-light performance, shallower depth-of-field capabilities, and improved overall image resolution.
•	Light sensitivity: larger sensors can gather more light, making them better suited for low-light conditions.
•	Depth-of-field control: smaller sensors have a shallower depth-of-field due to their smaller pixel pitch (distance between pixels).
•	Image resolution: generally speaking, larger sensors can accommodate higher resolutions and more megapixels.
The sensor size is usually given in inches, and it corresponds to the diameter of a circle with the same area of the sensor (rectangular shape). Some common sizes are: 1/1.8", 1/2", 1/2.3".

### Pixel Pitch and Interpixel Distance
Pixel Pitch and interpixel distance both have an impact on image quality and the ability of the sensor to pickup a signal in low-light conditions.

#### Pixel Pitch
Pixel Pitch refers to the distance between the centers of adjacent pixels on a sensor or image plane. A smaller pixel pitch means that the pixels are closer together, which can affect:
•	Image resolution: Higher resolutions require smaller pixel pitches for better detail and sharpness.
•	Depth-of-field control: Smaller pixel pitches enable shallower depth-of-field effects by allowing more precise focus adjustments.

> **Pixel pitch** ranges between small (2-5 μm), medium (4.8-6.7 μm), and large (9-12 μm)

#### Interpixel Distance
Interpixel Distance is the actual physical gap between adjacent pixels on a sensor or image plane. This value can be different from the pixel pitch, as IPD includes any gaps or spacing between pixels.

> The **interpixel distance** ranges are: small (2.5-6.4 μm), medium (3.8-7.1 μm), and large (5.9-10.2 μm)

When choosing a camera for high-resolution photography of small objects or details, look for cameras with smaller pixel pitches (e.g., 2-3 μm). Think about lighting conditions: in low-light situations, larger pixels with shorter interpixel distances can help improve image quality.

### Sensitivity & Dynamic Range

#### Camera sensitivity
Sensitivity refers to its ability to capture images in various lighting conditions. It's often measured by the camera's ISO (International Organization for Standardization) setting, which controls the amplification of the sensor's signal.

**High Sensitivity**. A high-sensitivity camera can capture more detail and produce a cleaner image at higher ISOs (>6400). This is useful in low-light conditions or when shooting with fast lenses. 
- Pros: better performance in low light
- Cons: increased noise and graininess, especially at high ISOs

**Low Sensitivity**: A low-sensitivity camera is better suited for bright lighting conditions or when using slow lenses. It tends to produce a cleaner image with less noise. 
- Pros: cleaner images with minimal noise and graininess
- Cons: limited performance in low light (<6400 ISO)

#### Dynamic range
Camera dynamic range refers to the difference between the brightest highlights and darkest shadows that can be captured within a single image. A higher dynamic range means more detail is preserved across both bright and dark areas.
When shooting in low-light conditions a high-sensitivity camera can help capture more detail and produce a cleaner image at higher ISOs. Cameras with lower dynamic ranges may struggle to capture scenes with extreme contrast in low-light conditions.

### Image Sensor Technologies for Specific Applications

#### High speed sensors
High-speed sensors are designed to capture images at extremely fast frame rates, often exceeding 1000 frames per second (fps).  High-speed sensors typically exhibit the following characteristics:

- Fast Frame Rates (>1000 fps)
- Short Exposure Times (e.g., microseconds)
- High Sensitivity to ensure that brief, intense light sources can be captured effectively.
- Low Noise: advanced noise reduction techniques or specialized image processing algorithms.
- Wide Dynamic Range to capture both bright highlights and dark shadows within the same frame.

CMOS sensors are commonly used in high-speed applications due to their fast readout times, low noise, and ability to handle high frame rates. CCD sensors can also be used for high-speed imaging, offering advantages such as higher sensitivity and better dynamic range.

The main challenges of high-speed camera acquisition are data storage and lighting conditions. Capturing high-frame-rate video requires significant storage capacity, which can be a challenge in itself. High-speed sensors often require specific lighting conditions or specialized illumination systems to ensure optimal performance.

#### Low-light sensors

Low-light sensors are designed to capture high-quality images or video in dimly lit environments, where the available light is limited. These cameras typically employ specialized image processing algorithms and noise reduction techniques to minimize the impact of low light on image quality. Low-light acquisition requires high sensitivity, noise reduction, and wide dynamic range. 


## 2. The Lens

When selecting a lens for a video camera for scientific applications in low-light conditions, consider these critical parameters
- Aperture
- Focal Length
- Focus range
- Mount Type

### Aperture 
The aperture measures how much light can enter the lens. Larger aperture values allow more light in. A common range of large values is from f/1.4 to f/2.8, which allows a good amount of light to reach the sensor.

### Focal Length
The focal length is the distance between the lens and sensor, measured in millimeters. Common ranges are 12-24 mm or 50-100 mm. Usually shorter focal lengths (4-8 mm) are preferred for imaging rodents in laboratory settings due to their wider angle of view (i.e. capture a larger ROI). Prime lenses (i.e. fixed focal length) are often better suited for scientific applications due to their lack of distortion. However, a multi-focal lens is more versatile and can be flexibly adapted to setups of varying dimensions.

### Focus range
The focus range refers to the distance between the closest object (or subject) that can be brought into sharp focus and the farthest object that remains in sharp focus. In other words, it's the total distance over which a lens can maintain its focusing capabilities. This is often expressed as a minimum or maximum value, depending on whether you're interested in close-up or distant objects.

### Mount Type
There are two main lens mounts for industrial-grade video camera: C-mount and CS-mount. They have distinct differences that can impact your camera's performance.
- **C-Mount** (12mm). The C-mount is a standardized mount with an internal diameter of 12 mm. It is the first (oldest) mount type.
- **CS-Mount** (17mm). The CS-mount is a more modern design with an internal diameter of 17 mm. it is becoming the industry standard for many applications due to its increased compatibility and versatility. With a larger internal diameter, CS-mount lenses can accommodate larger sensors and offer better image quality.

In some cases, adaptors can be used to convert between C-mount and CS-mount lenses; however, this may affect image quality.

## Improving Imaging in Low Light Conditions

Low-light imaging can be challenging, but with the right combination of camera settings and equipment, you can capture high-quality videos even in dimly lit environments. Here's a short guide to improve imaging in low-light conditions:
1.	Choose a lens that is designed to perform well in low-light conditions, such as one with a wide aperture (low f-stop number – between f/1.4 and f/2.8) and/or one that is permeable to infrared(IR) light.
2.	Adjust the camera's gain control to optimize sensitivity for your specific lighting conditions.
3.	Use an IR (or near-infrared) light source (IR illuminator) to enhance illumination of the acquisition area. Make sure that the camera can detect and capture IR light (i.e. no IR filter mounted on the sensor).
4.	A larger sensor size captures more light.
5.	Larger pixels (e.g., 6-8 μm) capture more light .

## Notes
1. llama3.1 8B q4 implemented via gpt4all (Nomic: <https://www.nomic.ai/gpt4all>) and executed on a Dell Precision 3630 equipped with Nvidia RTX2080, Windows 10.
2. llama3.1 8B originally developed by Meta (https://ai.meta.com/blog/meta-llama-3-1/)