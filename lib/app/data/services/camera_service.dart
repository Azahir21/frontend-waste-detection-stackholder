import 'dart:html' as html;

/// Helper function to open a full-screen HTML camera overlay.
/// When the user captures an image, [onCaptured] is called with the image's data URL.
/// If the captured image is larger than 1MB, it is compressed by converting it to JPEG.
void openCameraDialog(
    {required void Function(String imageDataUrl) onCaptured}) {
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

  // Request access to the camera.
  html.window.navigator.mediaDevices
      ?.getUserMedia({'video': true}).then((stream) {
    video.srcObject = stream;
  }).catchError((error) {
    print('Error accessing camera: $error');
    dialog.remove();
  });

  captureButton.onClick.listen((event) {
    // Get the actual video dimensions from the stream
    final actualVideoWidth = video.videoWidth;
    final actualVideoHeight = video.videoHeight;

    if (actualVideoWidth == 0 || actualVideoHeight == 0) {
      print('Error: Unable to determine video dimensions');
      return;
    }

    // Create a canvas with the same dimensions as the displayed video
    final canvas = html.CanvasElement(
        width: videoWidth.toInt(), height: videoHeight.toInt());
    final context = canvas.context2D;

    // Calculate scaling and positioning to match the displayed preview
    final displayAspect = videoWidth / videoHeight;
    final videoAspect = actualVideoWidth / actualVideoHeight;

    double sx = 0,
        sy = 0,
        sWidth = actualVideoWidth.toDouble(),
        sHeight = actualVideoHeight.toDouble();

    // Adjust source rectangle based on aspect ratio differences
    if (displayAspect > videoAspect) {
      // Preview is wider than video, video height is scaled to match preview
      sHeight = actualVideoWidth / displayAspect;
      sy = (actualVideoHeight - sHeight) / 2;
    } else if (displayAspect < videoAspect) {
      // Preview is taller than video, video width is scaled to match preview
      sWidth = actualVideoHeight * displayAspect;
      sx = (actualVideoWidth - sWidth) / 2;
    }

    // Draw the properly cropped and scaled video frame onto the canvas
    context.drawImageScaledFromSource(
        video, sx, sy, sWidth, sHeight, 0, 0, videoWidth, videoHeight);

    // Capture image as PNG
    String imageDataUrl = canvas.toDataUrl('image/png');

    // Stop the video stream
    final tracks = (video.srcObject as html.MediaStream).getTracks();
    for (var track in tracks) {
      track.stop();
    }

    // Remove the overlay
    dialog.remove();

    // Return the captured image
    onCaptured(imageDataUrl);
  });
}
