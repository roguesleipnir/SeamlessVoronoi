//https://github.com/Xentiie/SeamlessVoronoi

inline float3 modulo(float3 divident, float3 divisor)
{
  float3 positiveDivident = divident % divisor + divisor;
  return positiveDivident % divisor;
}

float rand3dTo1d(float3 value, float3 dotDir = float3(12.9898, 78.233, 37.719))
{
  //make value smaller to avoid artefacts
  float3 smallValue = sin(value);
  //get scalar value from 3d vector
  float random = dot(smallValue, dotDir);
  //make value more random by making it bigger and then taking the factional part
  random = frac(sin(random) * 143758.5453);
  return random;
}

float3 rand3dTo3d(float3 value)
{
  return float3(
    rand3dTo1d(value, float3(12.989, 78.233, 37.719)),
    rand3dTo1d(value, float3(39.346, 11.135, 83.155)),
    rand3dTo1d(value, float3(73.156, 52.235, 09.151))
  );
}

float3 voronoiNoise(float3 value, float3 period)
{
  float3 baseCell = floor(value);

  //first pass to find the closest cell
  float minDistToCell = 10;
  float3 toClosestCell;
  float3 closestCell;
  [unroll]
  for(int x1=-1; x1<=1; x1++){
    [unroll]
    for(int y1=-1; y1<=1; y1++){
      [unroll]
      for(int z1=-1; z1<=1; z1++){
        float3 cell = baseCell + float3(x1, y1, z1);
        float3 tiledCell = modulo(cell, period);
        float3 cellPosition = cell + rand3dTo3d(tiledCell);
        float3 toCell = cellPosition - value;
        float distToCell = length(toCell);
        if(distToCell < minDistToCell){
          minDistToCell = distToCell;
          closestCell = cell;
          toClosestCell = toCell;
        }
      }
    }
  }

  //second pass to find the distance to the closest edge
  float minEdgeDistance = 10;
  [unroll]
  for(int x2=-1; x2<=1; x2++){
    [unroll]
    for(int y2=-1; y2<=1; y2++){
      [unroll]
      for(int z2=-1; z2<=1; z2++){
        float3 cell = baseCell + float3(x2, y2, z2);
        float3 tiledCell = modulo(cell, period);
        float3 cellPosition = cell + rand3dTo3d(tiledCell);
        float3 toCell = cellPosition - value;

        float3 diffToClosestCell = abs(closestCell - cell);
        bool isClosestCell = diffToClosestCell.x + diffToClosestCell.y + diffToClosestCell.z < 0.1;
        if(!isClosestCell){
          float3 toCenter = (toClosestCell + toCell) * 0.5;
          float3 cellDifference = normalize(toCell - toClosestCell);
          float edgeDistance = dot(toCenter, cellDifference);
          minEdgeDistance = min(minEdgeDistance, edgeDistance);
        }
      }
    }
  }

  float random = rand3dTo1d(closestCell);
  return float3(minDistToCell, random, minEdgeDistance);
}

void CalculateVoronoi_float (float2 UV, float Height, float CellDensity, float3 Period, out float Voronoi, out float Cells, out float CellBorder)
{
  float3 value = float3(UV, Height) * CellDensity;
  float3 noise = voronoiNoise(value, Period);

  Voronoi = noise.x;
  Cells = noise.y;
  CellBorder = noise.z;
}