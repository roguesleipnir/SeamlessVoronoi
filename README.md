# SeamlessVoronoi
Seamless voronoi Subgraphs for ShaderGraph (Unity 2021.3).

Forked from: https://github.com/Xentiie/SeamlessVoronoi

Made with this tutorial: https://www.ronja-tutorials.com/2018/10/06/tiling-noise.html

## Subgraph: SeamlessVoronoi
Based on the original algorithm, created as a subgraph because the custom node syntax was outdated.

All needed scripts were moved to an HLSL file.

"UV": Texture UV coordinates.

"Offset": Variation offset for the cells. For example, multiply by a time node to animate it.

"Density": Density of the cells.

"Period": How often the voronoi noise will tile.

## Subgraph: PolarizeVoronoi
Warped voronoi noise to create a seamless circular pattern.

Useful for Dissolve Masking.

"UV": Rectangular texture UV coordinates. Will get polarized internally.

"RadialScale": Radial Scale of the polar coordinates.

"Density": Density of the cells. Only some values will produce a seamless texture. Use 1, 2, 4, 5, 8, 9, or 10.

"Period": How often the voronoi noise will tile.

"Speed": Animation speed of the cells. Multiplied with the internal Time node.

"Power": Intensity of the voronoi noise. 0 = Full opacity. 0 > Increases dissolve.
