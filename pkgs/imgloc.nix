scope: with scope; writeScriptBin pname ''
  #!${python3.withPackages (ps: [ ps.opencv4 ])}/bin/python
  import cv2, sys
  part_path, full_path = sys.argv[1:3]
  part = cv2.imread(part_path)
  full = cv2.imread(full_path)
  result = cv2.matchTemplate(full, part, cv2.TM_CCOEFF_NORMED)
  _, val, _, (x, y) = cv2.minMaxLoc(result)
  rows, cols, _ = part.shape
  if val > 0.8:
    print(f"x={x + cols // 2}")
    print(f"y={y + rows // 2}")
  else:
    print("x=")
    print("y=")
''