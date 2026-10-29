very performant ECS entity system for a 2d tower defense concept, can handle like 60k enemies with stable 40-30 fps and 15k with 60 fps

all done under 100kb bandwidth total for every client so the server doesnt even lag that much

no gui instances are made for each entity (or the map really) all of this is being edited on an ImageLabel with the help of EditableImage
(the map and entities are manually written into pixels with buffers that EditableImage can read, which is very performant as there's no
extra instances every second AT ALL)
