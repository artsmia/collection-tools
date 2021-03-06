This needs [our collection
data](https://github.com/artsmia/collection) to be cloned to your local
machine: `git clone --depth=1 https://github.com/artsmia/collection.git`.
Set the environment variable `MIA_COLLECTION` to point at that directory.

(If you have access to our secret internal private collection repo,
cloned to `<the same path>-private`, this will search that too. You'll
need to know `MIA_SEARCH_TOKEN` to search private records.)

# `mia`

matches an object id if the given term is numeric and there's a matching object
record. Otherwise it searches for the term (artist, accession number, …)
through our sphinx server.

```json
> mia 1411
1411 # (id is echoed to stderr)
{
  "accession_number": "61.36.14",
  "artist": "Henri Matisse",
  "continent": "Europe",
  "country": "France",
  "creditline": "Bequest of Putnam Dana McMillan",
  "culture": null,
  "dated": "1907",
  "description": "",
  "dimension": "23 3/4 x 28 3/4 x 15/16 in. (60.3 x 73.0 x 2.4 cm)",
  "id": "http://api.artsmia.org/objects/1411",
  "image": "valid",
  "image_copyright": "© Succession H. Matisse %2F Artists Rights Society %28ARS%29%2C New York",
  "image_height": 5045,
  "image_width": 6121,
  "life_date": "French, 1869 - 1954",
  "marks": "Signature; Inscriptions on verso: [no. 11] and [26 LL in ochre: [Henri-Matisse]",
  "medium": "Oil on canvas",
  "nationality": "French",
  "provenance": "Oskar and Greta Moll, Paris, France and Wroclaw, Poland. [1] Hodebert, Paris, France. Georges Bernheim, Paris, France (by 1931). [2] Dr. Jacques Soubies, Paris, France. [3] Léopold Zborowski [1889-1932], Paris (until 1937). (consigned to Galerie Simon/Mayor Gallery/Rains Gallery, New York City). [4] Gap from 1937-1950. [5] (Carstairs Gallery, New York City); [6] Putnam Dana McMillan, Minneapolis, Minnesota on May 9, 1950; bequest to MIA in 1961.\r\n\r\n[1] The Molls were German friends of Matisse and acquired the painting directly from him, according to recollections of Georges Keller of Carstairs Gallery in a letter of May 12, 1950. Keller also said that he acquired it directly from them in 1928 while still at the Galerie Georges Petit. If this is accurate or true, the next entry listed on the provenance should be: Galerie Georges Petit, Paris, 1928.\r\n\r\n[2] Mr. Bernheim is listed as the owner of this painting on a label (affixed on the middle brace of the painting's stretcher) for an exhibition titled 'Exposition HENRI-MATISSE' at the Galerie Georges Petit, Paris. This would confirm the reference in letters from the McMillan archive file (letters, May 12 and June 26, 1950) which notes that this painting was at the \"great Matisse show held at the Galerie Georges Petit in Paris in 1931\" which, however, arrived too late to be in the catalogue. The June 26 letter also says that the painting \"remained in France until it was brought to the US in approximately early 1950.\" This is conflicted by the information in the Zborowski entry, below.\r\n\r\n[3] La Galerie Simon, 1935-1936. \"Dr.\" is given in a letter of June 26, 1950 to Dick Davis from the Carstairs Gallery giving the provenance of this painting. There was a Soubies sale at the Hotel Drouot, Paris, December 13, 1940. An additional Soubies sale was held June 14, 1928.\r\n\r\n[4] Art Digest XI, April 15, 1937, p. 34, notes an auction that will take place at the Rains Galleries in New York City on April 23, 1937 that will disperse the paintings \"formerly in the collection of Mm",
  "restricted": 1,
  "role": "Artist",
  "room": "G371",
  "style": "20th century",
  "text": "This painting, like Boy with a Butterfly Net, dates from Matisse’s immediate post-Fauvist period, and is a characteristic example of his painting to its most elemental. Broad blocks of color indicate land, water and sky. The thick contour lines defining the bathers seem pictorial and sculptural at the same time, and indicate Matisse’s struggle to reconcile volume and two-dimensional design through reductive means.\r\n \r\nThree Bathers relates to Matisse’s much larger Bathers with a Turtle from 1908, now in the St. Louis Art Museum. These paintings inaugurated a period of artistic experimentation that culminated in Matisse’s monumental painting known as The Dance.",
  "title": "Three Bathers"
} # (`jq` printed JSON for result)
… # possibly subsequent results
```

Terms are split by spaces. To search for more than one word, surround
them with quotes: `mia 'three bathers 1907'`.

The results are valid JSON on `stdout`, so they can be piped to `jq` and
other tools that take JSON input:

```csv
> mia lyonel | jq -s '.' | json2csv -f title,artist,room,image,image_width,image_height
1425
114710
1268
7871
9770
23147
42135
42265
43418
43591
53588

"title","artist","room","image","image_width","image_height"
"Gross-Kromsdorf I","Lyonel Feininger","G367","valid",4840,6066
"Blue Coast","Lyonel Feininger","Not on View","valid",8933,5279
"Hopfgarten","Lyonel Feininger","Not on View","valid",6532,5039
"Promenaders (Spaziergänger)","Lyonel Feininger","Not on View","valid",6465,8026
"Harbor","Lyonel Feininger","Not on View","valid",4789,3108
"Figure Study","Lyonel Feininger","Not on View","valid",3499,4008
"Lehnstedt","Lyonel Feininger","Not on View","invalid","",""
"Evening Greetings","Lyonel Feininger","Not on View","invalid","",""
"Marine","Lyonel Feininger","Not on View","invalid","",""
"Marine 1","Lyonel Feininger","Not on View","invalid","",""
"Marine","Lyonel Feininger","Not on View","invalid","",""
```

# `tombstone`

```sh
> tombstone monet
1413 # (id to stderr)
Claude Monet
The Japanese Bridge
Bequest of Putnam Dana McMillan
61.36.15 # (artist, object title, credit, accession #)

10436
Claude Monet
Grainstack, Sun in the Mist
Gift of Ruth and Bruce Dayton, The Putnam Dana McMillan Fund, The John R. Van Derlip Fund, The William Hood Dunwoody Fund, The Ethel Morrison Van Derlip Fund, Alfred and Ingrid Lenz Harrison, and Mary Joann and James R. Jundt
93.20

1234
Claude Monet
The Seashore at Sainte-Adresse
Gift of Mr. and Mrs. Theodore Bennett
53.13

3267
Claude Monet
Still Life with Pheasants and Plovers
Gift of Anne Pierce Rogers in memory of John DeCoster Rogers
84.140

…
```

# `miamg`

Download an image at full res from the API (internal only)

# `mia-recache`

Does the gruntwork of replacing an image in multiple cache locations. Work
in progress. So far this replaces thumbnail images (stored on S3). Needs
to also handle replacing the image on our internal and external API
servers and the full-size tiled version of an image.
