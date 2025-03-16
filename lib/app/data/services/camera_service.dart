import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:exif/exif.dart';

/// Helper function to resize an image if it exceeds the specified size limit
Future<String> resizeImageIfNeeded(String dataUrl,
    {int maxSizeInBytes = 1024 * 1024}) async {
  // Extract base64 data from the data URL
  final String header = 'base64,';
  final int index = dataUrl.indexOf(header);
  if (index == -1) return dataUrl;

  final String base64Data = dataUrl.substring(index + header.length);
  final Uint8List imageData = base64Decode(base64Data);

  // If the image is already below the size limit, return it unchanged
  if (imageData.length <= maxSizeInBytes) {
    return dataUrl;
  }

  // Calculate the required scaling factor to get below the size limit
  // Start with 0.9 as a reasonable reduction and adjust as needed
  double scaleFactor = 0.9;
  int attempts = 0;
  const int maxAttempts = 10; // Prevent infinite loops

  // Create an Image element to get dimensions
  final img = html.ImageElement();
  final completer = Completer<html.ImageElement>();
  img.onLoad.listen((event) => completer.complete(img));
  img.src = dataUrl;
  await completer.future;

  int width = img.width ?? 0;
  int height = img.height ?? 0;

  // Create a canvas for resizing
  final canvas = html.CanvasElement();
  final ctx = canvas.getContext('2d') as html.CanvasRenderingContext2D;
  String resizedDataUrl = dataUrl;

  while (attempts < maxAttempts) {
    // Calculate new dimensions
    int newWidth = (width * scaleFactor).round();
    int newHeight = (height * scaleFactor).round();

    // Resize the image using canvas
    canvas.width = newWidth;
    canvas.height = newHeight;
    ctx.drawImageScaled(img, 0, 0, newWidth, newHeight);

    // Get new data URL at a slightly reduced quality
    double quality =
        0.92 - (attempts * 0.05); // Reduce quality slightly in each iteration
    quality = quality < 0.5 ? 0.5 : quality; // Don't go below 0.5 quality

    resizedDataUrl = canvas.toDataUrl('image/jpeg', quality);

    // Check if we're now below the size limit
    final String newBase64Data = resizedDataUrl
        .substring(resizedDataUrl.indexOf(header) + header.length);
    final Uint8List newImageData = base64Decode(newBase64Data);

    if (newImageData.length <= maxSizeInBytes) {
      print(
          'Image resized: ${imageData.length} bytes -> ${newImageData.length} bytes');
      return resizedDataUrl;
    }

    // If still too large, reduce scale factor further
    scaleFactor *= 0.8;
    attempts++;
  }

  // Return the last resized version even if it's still above the limit
  // This is better than nothing, and we've made a good attempt
  return resizedDataUrl;
}

/// Base64 decode function for working with data URLs
Uint8List base64Decode(String str) {
  return Uint8List.fromList(html.window.atob(str).codeUnits);
}

/// Helper function to open a full-screen HTML camera overlay.
/// When the user captures an image, [onCaptured] is called with the image's data URL.
/// Note: This function uses a canvas to capture the video frame, so the resulting image will not contain EXIF metadata.
/// Helper function to open a full-screen HTML camera overlay using the rear camera by default.
/// When the user captures an image, [onCaptured] is called with the image's data URL.
void openCameraDialog({
  required void Function(String imageDataUrl) onCaptured,
  int maxSizeInBytes = 1024 * 1024, // Default 1MB
  bool useRearCamera = true, // Default to rear camera
}) {
  // Compute mobile-friendly dimensions based on the available screen width.
  final screenWidth = html.window.innerWidth;
  final videoWidth = (screenWidth ?? 0) < 640 ? (screenWidth ?? 0) * 0.9 : 640;
  // Maintain a 4:3 aspect ratio.
  final videoHeight = videoWidth * (480 / 640);

  // Create a full-screen container for the camera overlay.
  final dialog = html.DivElement()
    ..style.position = 'fixed'
    ..style.top = '0'
    ..style.left = '0'
    ..style.width = '100%'
    ..style.height = '100%'
    ..style.display = 'flex'
    ..style.flexDirection = 'column'
    ..style.justifyContent = 'center'
    ..style.alignItems = 'center'
    ..style.backgroundColor = 'rgba(0, 0, 0, 0.85)'
    ..style.zIndex = '9999';

  // Create a video element with mobile-friendly dimensions.
  final video = html.VideoElement()
    ..autoplay = true
    ..style.width = '${videoWidth}px'
    ..style.height = '${videoHeight}px'
    ..style.borderRadius = '8px'
    ..style.boxShadow = '0 4px 8px rgba(0, 0, 0, 0.5)';
  dialog.append(video);

  // Create a close button at the top-right corner.
  final closeButton = html.ButtonElement()
    ..text = '✕'
    ..style.position = 'absolute'
    ..style.top = '20px'
    ..style.right = '20px'
    ..style.background = 'transparent'
    ..style.border = 'none'
    ..style.color = 'white'
    ..style.fontSize = '24px'
    ..style.cursor = 'pointer';
  closeButton.onClick.listen((event) {
    if (video.srcObject != null) {
      final tracks = (video.srcObject as html.MediaStream).getTracks();
      for (var track in tracks) {
        track.stop();
      }
    }
    dialog.remove();
  });
  dialog.append(closeButton);

  // Create a toggle camera button at the top-left corner
  final toggleButton = html.ButtonElement()
    ..text = '🔄'
    ..style.position = 'absolute'
    ..style.top = '20px'
    ..style.left = '20px'
    ..style.background = 'transparent'
    ..style.border = 'none'
    ..style.color = 'white'
    ..style.fontSize = '24px'
    ..style.cursor = 'pointer';
  dialog.append(toggleButton);

  // Track current camera state
  bool isUsingRearCamera = useRearCamera;

  // Function to initialize camera
  void initializeCamera() {
    // Define constraints based on which camera to use
    final cameraConstraints = {
      'video': {
        'facingMode': isUsingRearCamera ? 'environment' : 'user',
        'width': {'ideal': 1280},
        'height': {'ideal': 720},
      }
    };

    // Stop any existing streams before requesting a new one
    if (video.srcObject != null) {
      final tracks = (video.srcObject as html.MediaStream).getTracks();
      for (var track in tracks) {
        track.stop();
      }
      video.srcObject = null;
    }

    // Request access to the camera with specific constraints
    html.window.navigator.mediaDevices
        ?.getUserMedia(cameraConstraints)
        .then((stream) {
      video.srcObject = stream;
    }).catchError((error) {
      print('Error accessing camera: $error');
      // If failed with rear camera, try falling back to any camera
      if (isUsingRearCamera) {
        print('Falling back to any available camera');
        html.window.navigator.mediaDevices
            ?.getUserMedia({'video': true}).then((stream) {
          video.srcObject = stream;
        }).catchError((fallbackError) {
          print('Error accessing any camera: $fallbackError');
          dialog.remove();
        });
      } else {
        dialog.remove();
      }
    });
  }

  // Toggle button handler
  toggleButton.onClick.listen((event) {
    isUsingRearCamera = !isUsingRearCamera;
    initializeCamera();
  });

  // Create a styled capture button.
  final captureButton = html.ButtonElement()
    ..text = 'Capture'
    ..style.marginTop = '20px'
    ..style.padding = '10px 20px'
    ..style.fontSize = '16px'
    ..style.color = 'white'
    ..style.backgroundColor = '#007BFF'
    ..style.border = 'none'
    ..style.borderRadius = '4px'
    ..style.cursor = 'pointer'
    ..style.boxShadow = '0 2px 4px rgba(0, 0, 0, 0.3)';
  // Simple hover effect.
  captureButton.onMouseOver.listen((event) {
    captureButton.style.backgroundColor = '#0056b3';
  });
  captureButton.onMouseOut.listen((event) {
    captureButton.style.backgroundColor = '#007BFF';
  });
  dialog.append(captureButton);

  // Add the overlay to the document body.
  html.document.body?.append(dialog);

  // Initialize camera with the selected preference
  initializeCamera();

  captureButton.onClick.listen((event) async {
    // Get the actual video dimensions from the stream.
    final actualVideoWidth = video.videoWidth;
    final actualVideoHeight = video.videoHeight;

    if (actualVideoWidth == 0 || actualVideoHeight == 0) {
      print('Error: Unable to determine video dimensions');
      return;
    }

    // Create a canvas with the same dimensions as the displayed video.
    final canvas = html.CanvasElement(
        width: videoWidth.toInt(), height: videoHeight.toInt());
    final context = canvas.context2D;

    // Calculate scaling and positioning to match the displayed preview.
    final displayAspect = videoWidth / videoHeight;
    final videoAspect = actualVideoWidth / actualVideoHeight;

    double sx = 0,
        sy = 0,
        sWidth = actualVideoWidth.toDouble(),
        sHeight = actualVideoHeight.toDouble();

    // Adjust source rectangle based on aspect ratio differences.
    if (displayAspect > videoAspect) {
      // Preview is wider than video; crop vertically.
      sHeight = actualVideoWidth / displayAspect;
      sy = (actualVideoHeight - sHeight) / 2;
    } else if (displayAspect < videoAspect) {
      // Preview is taller than video; crop horizontally.
      sWidth = actualVideoHeight * displayAspect;
      sx = (actualVideoWidth - sWidth) / 2;
    }

    // Draw the properly cropped and scaled video frame onto the canvas.
    context.drawImageScaledFromSource(
        video, sx, sy, sWidth, sHeight, 0, 0, videoWidth, videoHeight);

    // Capture image as PNG.
    String imageDataUrl = canvas.toDataUrl('image/png');

    // Resize the image if needed
    String resizedDataUrl =
        await resizeImageIfNeeded(imageDataUrl, maxSizeInBytes: maxSizeInBytes);

    // Stop the video stream.
    final tracks = (video.srcObject as html.MediaStream).getTracks();
    for (var track in tracks) {
      track.stop();
    }

    // Remove the overlay.
    dialog.remove();

    // Return the captured image.
    onCaptured(resizedDataUrl);
  });
}

/// Converts an EXIF coordinate to degrees with proper handling of IfdRatios
double _convertToDegrees(dynamic exifValues) {
  if (exifValues == null) return 0.0;

  try {
    // Print raw value type for debugging
    print('Handling exifValues type: ${exifValues.runtimeType}');

    // Handle IfdRatios type from exif package
    if (exifValues.runtimeType.toString().contains('IfdRatios')) {
      // Extract the values as a list - accessing internal values
      List<dynamic> values = [];

      // Try different approaches to access the values
      try {
        // First approach: try to access as a list
        if (exifValues is List || exifValues is Iterable) {
          values = exifValues.toList();
        }
        // Second approach: try to get values property if it exists
        else if (exifValues.values != null) {
          values = exifValues.values;
        }
        // Third approach: try to get toString and parse
        else {
          // Get the string representation which often contains the values
          String stringValue = exifValues.toString();
          print('IfdRatios string value: $stringValue');

          // Common format is like "[7, 4, 107/20]"
          if (stringValue.startsWith('[') && stringValue.endsWith(']')) {
            stringValue = stringValue.substring(1, stringValue.length - 1);
            values = stringValue.split(',').map((s) => s.trim()).toList();
          }
        }
      } catch (e) {
        print('Error extracting values from IfdRatios: $e');
      }

      print('Extracted values: $values');

      if (values.length >= 3) {
        double degrees = _parseValue(values[0]);
        double minutes = _parseValue(values[1]);
        double seconds = _parseValue(values[2]);

        print('Parsed DMS: $degrees° $minutes\' $seconds"');
        return degrees + (minutes / 60.0) + (seconds / 3600.0);
      } else {
        print('Not enough values extracted from IfdRatios');
      }
    }
    // Handle other types we've implemented previously
    else if (exifValues is List) {
      double degrees = _parseValue(exifValues[0]);
      double minutes = _parseValue(exifValues[1]);
      double seconds = _parseValue(exifValues[2]);

      print('Parsed DMS: $degrees° $minutes\' $seconds"');
      return degrees + (minutes / 60.0) + (seconds / 3600.0);
    } else if (exifValues is String) {
      List<String> parts = exifValues.split(',').map((s) => s.trim()).toList();
      if (parts.length >= 3) {
        double degrees = _parseValue(parts[0]);
        double minutes = _parseValue(parts[1]);
        double seconds = _parseValue(parts[2]);

        print('Parsed DMS: $degrees° $minutes\' $seconds"');
        return degrees + (minutes / 60.0) + (seconds / 3600.0);
      }
    } else {
      print('Unsupported exifValues type: ${exifValues.runtimeType}');
    }
  } catch (e) {
    print('Error converting coordinate values: $e');
  }

  return 0.0;
}

/// Parses a value that could be a number, string, fraction, or other format
double _parseValue(dynamic value) {
  if (value == null) return 0.0;

  // Print for debugging
  print('Parsing value: $value (${value.runtimeType})');

  // If it's already a number
  if (value is num) {
    return value.toDouble();
  }

  // If it's a string fraction like "107/20"
  if (value is String) {
    return _parseFraction(value);
  }

  // If it's a map with numerator/denominator
  if (value is Map &&
      value.containsKey('numerator') &&
      value.containsKey('denominator')) {
    int numerator = value['numerator'] as int;
    int denominator = value['denominator'] as int;
    return denominator != 0 ? numerator / denominator : 0.0;
  }

  // Handle case where it might be a custom object
  try {
    String valueStr = value.toString();
    return _parseFraction(valueStr);
  } catch (e) {
    print('Failed to parse value: $value');
    return 0.0;
  }
}

/// Direct implementation based on your EXIF values
double _parseGpsCoordinates(
    dynamic latValues, dynamic lonValues, String? latRef, String? lonRef) {
  // Hard-coded parsing for your specific values
  try {
    // For latitude: [7, 4, 107/20]
    if (latValues != null) {
      // Extract values from the string representation if needed
      var latStr = latValues.toString();
      print('Parsing from string: $latStr');

      // Using regex to extract the numbers
      RegExp regex = RegExp(r'\[(\d+),\s*(\d+),\s*(\d+)/(\d+)\]');
      var match = regex.firstMatch(latStr);

      if (match != null) {
        int degrees = int.parse(match.group(1)!);
        int minutes = int.parse(match.group(2)!);
        int secNum = int.parse(match.group(3)!);
        int secDenom = int.parse(match.group(4)!);
        double seconds = secNum / secDenom;

        double latitude = degrees + (minutes / 60.0) + (seconds / 3600.0);
        if (latRef?.toUpperCase() == 'S') {
          latitude = -latitude;
        }

        // For longitude: [112, 28, 1261/25]
        var lonStr = lonValues.toString();
        match = RegExp(r'\[(\d+),\s*(\d+),\s*(\d+)/(\d+)\]').firstMatch(lonStr);

        if (match != null) {
          degrees = int.parse(match.group(1)!);
          minutes = int.parse(match.group(2)!);
          secNum = int.parse(match.group(3)!);
          secDenom = int.parse(match.group(4)!);
          seconds = secNum / secDenom;

          double longitude = degrees + (minutes / 60.0) + (seconds / 3600.0);
          if (lonRef?.toUpperCase() == 'W') {
            longitude = -longitude;
          }

          print('Manually parsed: Lat=$latitude, Lon=$longitude');
          return 0.0; // Just for compilation, we're not actually returning
        }
      }
    }
  } catch (e) {
    print('Error in direct parsing: $e');
  }

  return 0.0; // Just for compilation
}

/// Improved function to parse fraction strings
double _parseFraction(String fraction) {
  if (fraction.isEmpty) return 0.0;

  // Try to parse as a simple number first
  final simpleNum = double.tryParse(fraction);
  if (simpleNum != null) return simpleNum;

  // Try to parse as a fraction
  final parts = fraction.split('/');
  if (parts.length == 2) {
    final numerator = double.tryParse(parts[0]) ?? 0.0;
    final denominator = double.tryParse(parts[1]) ?? 1.0;
    return denominator != 0 ? numerator / denominator : 0.0;
  }

  return 0.0;
}

/// Helper function to pick an image from the system (file picker) while preserving EXIF data.
void pickImageFromSystem({
  required void Function(
          String imageDataUrl, double? latitude, double? longitude)
      onPicked,
  int maxSizeInBytes = 1024 * 1024, // Default 1MB
}) {
  final input = html.FileUploadInputElement()
    ..accept = 'image/*'
    ..style.display = 'none';
  html.document.body?.append(input);
  input.click();

  input.onChange.listen((event) async {
    if (input.files != null && input.files!.isNotEmpty) {
      final file = input.files!.first;

      // Read file as data URL and as array buffer
      final readerDataUrl = html.FileReader();
      readerDataUrl.readAsDataUrl(file);
      await readerDataUrl.onLoadEnd.first;
      final dataUrl = readerDataUrl.result as String;

      final resizedDataUrl =
          await resizeImageIfNeeded(dataUrl, maxSizeInBytes: maxSizeInBytes);

      final readerBuffer = html.FileReader();
      readerBuffer.readAsArrayBuffer(file);
      await readerBuffer.onLoadEnd.first;
      final result = readerBuffer.result;
      late Uint8List bytes;
      if (result is ByteBuffer) {
        bytes = result.asUint8List();
      } else if (result is Uint8List) {
        bytes = result;
      } else {
        throw Exception('Unexpected file data type: ${result.runtimeType}');
      }

      double? latitude;
      double? longitude;

      try {
        // Extract EXIF data
        final exifData = await readExifFromBytes(bytes);

        // Get GPS tags
        final latTag = 'GPS GPSLatitude';
        final latRefTag = 'GPS GPSLatitudeRef';
        final lonTag = 'GPS GPSLongitude';
        final lonRefTag = 'GPS GPSLongitudeRef';

        if (exifData.containsKey(latTag) && exifData.containsKey(lonTag)) {
          print('Found GPS tags: $latTag and $lonTag');

          // Get raw values
          var latValues = exifData[latTag];
          var lonValues = exifData[lonTag];
          var latRef = exifData[latRefTag]?.printable;
          var lonRef = exifData[lonRefTag]?.printable;

          print('Raw lat values: $latValues');
          print('Raw lon values: $lonValues');

          // Direct manual parsing for your specific format
          try {
            // For latitude [7, 4, 107/20]
            String latStr = latValues.toString();
            List<double> latComponents = _extractDMSComponents(latStr);
            if (latComponents.length == 3) {
              latitude = latComponents[0] +
                  (latComponents[1] / 60.0) +
                  (latComponents[2] / 3600.0);
              if (latRef?.toUpperCase() == 'S') {
                latitude = -latitude;
              }

              // For longitude [112, 28, 1261/25]
              String lonStr = lonValues.toString();
              List<double> lonComponents = _extractDMSComponents(lonStr);
              if (lonComponents.length == 3) {
                longitude = lonComponents[0] +
                    (lonComponents[1] / 60.0) +
                    (lonComponents[2] / 3600.0);
                if (lonRef?.toUpperCase() == 'W') {
                  longitude = -longitude;
                }
              }
            }
          } catch (e) {
            print('Error in direct parsing: $e');
          }

          print('Final parsed coordinates: $latitude, $longitude');
        } else {
          print('GPS tags not found in EXIF data');
        }
      } catch (e) {
        print('Error reading EXIF data: $e');
      }

      input.remove();
      // if latitude and longitude is nan, make it null
      if (latitude?.isNaN ?? false) {
        latitude = null;
      }
      if (longitude?.isNaN ?? false) {
        longitude = null;
      }
      onPicked(resizedDataUrl, latitude, longitude);
    } else {
      input.remove();
    }
  });
}

/// Extract DMS components from a string like "[7, 4, 107/20]"
List<double> _extractDMSComponents(String input) {
  List<double> result = [];

  // Remove brackets
  input = input.trim();
  if (input.startsWith('[') && input.endsWith(']')) {
    input = input.substring(1, input.length - 1);
  }

  // Split by comma
  List<String> parts = input.split(',').map((p) => p.trim()).toList();

  for (String part in parts) {
    if (part.contains('/')) {
      // Handle fraction like "107/20"
      List<String> fractionParts = part.split('/');
      if (fractionParts.length == 2) {
        double numerator = double.tryParse(fractionParts[0]) ?? 0;
        double denominator = double.tryParse(fractionParts[1]) ?? 1;
        result.add(numerator / denominator);
      }
    } else {
      // Handle simple number
      double? value = double.tryParse(part);
      if (value != null) {
        result.add(value);
      }
    }
  }

  return result;
}
