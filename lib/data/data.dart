import 'package:flutter/material.dart';
import 'package:jungle/models/models.dart';
import 'package:uuid/uuid.dart';

final List<Activity> bars = [
  Activity(
    aid: Uuid().v4(),
    popularity: 3,
    price: '\$',
    type: 'bar',
    name: "El Jefe",
    tag: 'College Night Club',
    address: '1120 W University Ave',
    images: [
      "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2F146272654_110878604326371_5334132869846446776_n.jpg?alt=media&token=3bfbbd7a-c683-4f58-bdde-fef85573e4ac"
    ],
  ),
  Activity(
    aid: Uuid().v4(),
    popularity: 15,
    price: '\$',
    type: 'bar',
    name: "Fat Daddy's",
    tag: 'College Night Club',
    address: '1702 W University Ave Suite A1, Gainesville, FL 32603',
    images: [
      "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2F146272654_110878604326371_5334132869846446776_n.jpg?alt=media&token=3bfbbd7a-c683-4f58-bdde-fef85573e4ac"
    ],
  ),
  Activity(
    aid: Uuid().v4(),
    popularity: 14,
    price: '\$',
    type: 'bar',
    name: "JJ's Tavern",
    tag: 'Traditional Bar',
    address: '1702 W University Ave Suite G, Gainesville, FL 32603',
    images: [
      "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2Fattachment_84857448-2.jpeg?alt=media&token=8980135a-acae-4101-99ed-cb53309522a4"
    ],
  ),
  Activity(
    aid: Uuid().v4(),
    popularity: 13,
    price: '\$',
    type: 'bar',
    name: "Tatu",
    tag: 'Bar & Grill',
    address: '1702 W University Ave J, Gainesville, FL 32603',
    images: [
      "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2Fo.jpg?alt=media&token=83540bf3-e4ac-4a60-af34-d5e02643766a"
    ],
  ),
  Activity(
      aid: Uuid().v4(),
      popularity: 0,
      price: '\$\$',
      type: 'bar',
      name: "Simon's",
      tag: 'Night Club',
      address: '8 S Main St, Gainesville, FL 32601',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2Fsimons-nightclub.jpg?alt=media&token=aff8d4dd-b8c0-402f-9d52-31b29002f362"
      ],
      description: null),
  Activity(
      aid: Uuid().v4(),
      popularity: 8,
      price: '\$',
      type: 'bar',
      name: "Grog",
      tag: 'College Bar',
      address: '1718 W University Ave, Gainesville, FL 32603',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2FRJQDM3NPRJHMVNISKXFYYHDZCM.jpg?alt=media&token=60637fe4-963d-45a8-a379-2d74ab60b650"
      ],
      description: null),
  Activity(
      aid: Uuid().v4(),
      popularity: 7,
      price: '\$',
      type: 'bar',
      name: "Salty Dog Saloon",
      tag: 'Old-Fashioned Bar',
      address: '1712 W University Ave, Gainesville, FL 32603',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2F101501198_697228147514254_1435605730701477071_n.jpg?alt=media&token=6baab6e1-f0ae-4618-aec0-ece1a79c929a"
      ],
      description: null),
  Activity(
      aid: Uuid().v4(),
      popularity: 9,
      price: '\$\$',
      type: 'bar',
      name: "The Social",
      tag: 'Sports Bar & Restaurant',
      address: '1728 W University Ave, Gainesville, FL 32603',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2F129731518_806886096537863_3813139796599215757_n.jpg?alt=media&token=83f67ea4-7dba-4e5b-833a-cf0eeec7cd47"
      ],
      description: null),
  Activity(
      aid: Uuid().v4(),
      popularity: 13,
      price: '\$',
      type: 'bar',
      name: "Rowdy Reptile",
      tag: 'American Bar',
      address: '1702 W University Ave Suite A1, Gainesville, FL 32603',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2Fl.jpg?alt=media&token=89f06f6b-f5ae-4f92-81ab-a2b0348f7e75"
      ],
      description: null),
  Activity(
      aid: Uuid().v4(),
      popularity: 5,
      price: '\$\$',
      type: 'bar',
      name: "White Buffalo",
      tag: 'College Bar',
      address: '111 S Main St, Gainesville, FL 32601',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2F102404482_957109758064830_6368971491856859158_n.jpg?alt=media&token=863f2a29-f126-4406-8173-e213a3fef479"
      ],
      description: null),
  Activity(
      aid: Uuid().v4(),
      popularity: 6,
      price: '\$\$',
      type: 'bar',
      name: "Downtown Fats",
      tag: 'College Bar',
      address: '112 S Main St, Gainesville, FL 32601',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2F121574849_384181839419847_8553776110686228923_n.jpg?alt=media&token=580a2c5b-0593-41bc-b5c0-db7bd53d4fa6"
      ],
      description: null),
  Activity(
      aid: Uuid().v4(),
      popularity: 1,
      price: '\$',
      type: 'bar',
      name: "Gainesville Arcade Bar",
      tag: 'Arcade Bar',
      address: '6 E University Ave',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2F186416_1453404679.jpg?alt=media&token=0f580424-9b1b-41d0-841a-008ce56f3094"
      ],
      description: null),
  Activity(
      aid: Uuid().v4(),
      popularity: 2,
      price: '\$',
      type: 'bar',
      name: "Mother's",
      tag: 'Bar & Grill',
      address: '1017 W University Ave',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2Forigin.jpg?alt=media&token=52d4b2c1-0582-4f4f-80e3-573581203f08"
      ],
      description: null),
  Activity(
      aid: Uuid().v4(),
      popularity: 4,
      price: '\$',
      type: 'bar',
      name: "The Lab",
      tag: 'Bar & Night Club',
      address: '18 W University Ave',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2F132000121_308236827172547_589280893594315925_n.jpg?alt=media&token=c1909cf0-0606-49b0-8ef1-932cd7f1b6b4"
      ],
      description: null),
];

final List<Activity> rests = [
  Activity(
      aid: Uuid().v4(),
      popularity: 10,
      type: 'restaurant',
      price: '\$\$\$',
      name: "Dragon Fly",
      tag: 'Sushi restaurant',
      address: '201 SE 2nd Ave #104, Gainesville, FL 32601',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2FINT_SUSHI.png?alt=media&token=bd0da44e-7959-4129-901d-bd84d64ad1cd"
      ],
      description:
          "Contemporary izakaya featuring tapas-style Japanese pub fare plus an assortment of sake."),
  Activity(
      aid: Uuid().v4(),
      popularity: 4,
      type: 'restaurant',
      price: '\$\$',
      name: "Crane Ramen",
      tag: "Ramen Restaurant",
      address: '16 SW 1 Ave, Gainesville, FL 32601',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2FAR-604154372.jpg?alt=media&token=ee7700e4-2149-441c-908e-a6cf2896273d"
      ],
      description:
          "Hip Japanese locale crafting ramen made with area-sourced ingredients, plus unique cocktails."),
  Activity(
      aid: Uuid().v4(),
      popularity: 3,
      type: 'restaurant',
      price: '\$\$',
      name: "The Top",
      tag: 'American Restuarant',
      address: '30 N Main St, Gainesville, FL 32601',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2Fthe-top-ext2.jpg?alt=media&token=0da38eb7-ae2e-41ed-9aff-eb272b1b8e15"
      ],
      description: null),
  Activity(
      aid: Uuid().v4(),
      popularity: 0,
      type: 'restaurant',
      price: '\$\$\$\$',
      name: "Mark's Prime",
      tag: 'Steak House',
      address: '201 SE 2nd Ave #102',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2Fdefault_header_image_large.jpg?alt=media&token=f5c6b26d-c111-4140-b1e0-7623ccb99526"
      ],
      description: null),
  Activity(
      aid: Uuid().v4(),
      popularity: 0,
      type: 'restaurant',
      price: '\$\$',
      name: "Amelia's",
      tag: 'Italian restaurant',
      address: '235 S Main St Suite 107',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2Famelias-exterior-sign.jpg?alt=media&token=1c3438d0-e49b-4426-8d61-6c78bbd108f4"
      ],
      description: null),
  Activity(
      aid: Uuid().v4(),
      popularity: 0,
      type: 'restaurant',
      price: '\$\$',
      name: "Big Top",
      tag: 'Brewery',
      address: '201 SE 2nd Ave #101',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2F141581081_2823757017944322_4263937343203369429_n.jpg?alt=media&token=7bd047bf-81bd-4ce1-9f69-b769d1f97bc4"
      ],
      description: null),
  Activity(
      aid: Uuid().v4(),
      popularity: 0,
      type: 'restaurant',
      price: '\$\$',
      name: "Harry's",
      tag: 'Seafood Restaurant',
      address: '110 SE First St Unit A',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2FHarrys-Seafood-Bar-Grille-celebrates-22-years-in-business-with-a-customer-appreciation-event.jpeg?alt=media&token=46631551-9e2d-4d54-81ef-147bc9ba32c1"
      ],
      description: null),
  Activity(
      aid: Uuid().v4(),
      popularity: 0,
      type: 'restaurant',
      price: '\$\$',
      name: "Boca Fiesta",
      tag: 'Mexican Restaurant',
      address: '232 SE 1st St, Gainesville',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2FIMG_5788.jpg?alt=media&token=5c37b106-c8fa-4a62-a170-39c38f8cc22a"
      ],
      description: null),
  Activity(
      aid: Uuid().v4(),
      popularity: 2,
      type: 'restaurant',
      price: '\$\$',
      name: "OAK",
      tag: 'American restaurant',
      address: '15 SE 1st Ave',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2F5e8a614460516.image.jpg?alt=media&token=7df00b41-9fb2-40f9-8225-50d7ffddf58a"
      ],
      description: null),
  Activity(
      aid: Uuid().v4(),
      popularity: 0,
      type: 'restaurant',
      price: '\$\$',
      name: "Cheesecake Factory",
      tag: 'Dessert restaurant',
      address: '2851 SW 35th Dr',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2FDSC_6851.jpg?alt=media&token=e955823d-9de3-4aad-bc04-1cc02f15e58b"
      ],
      description: null),
  Activity(
      aid: Uuid().v4(),
      popularity: 0,
      type: 'restaurant',
      price: '\$\$',
      name: "V Pizza",
      tag: 'Pizza restaurant',
      address: '115 SE 1 St',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2F061317-V-Pizza-42.jpg?alt=media&token=d6f13430-8e17-40fe-b195-111f9490199f"
      ],
      description: null),
  Activity(
      aid: Uuid().v4(),
      popularity: 0,
      type: 'restaurant',
      price: '\$\$',
      name: "Ember's",
      tag: 'Steakhouse',
      address: '3545 SW 34th St A',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2Funnamed.jpg?alt=media&token=a3366acb-12fb-4473-9d8d-0023506a8998"
      ],
      description: null),
  Activity(
      aid: Uuid().v4(),
      popularity: 0,
      type: 'restaurant',
      price: '\$\$',
      name: "Piesanos",
      tag: 'Italian restaurant',
      address: '1250 W University Ave',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2Fpiesanos-restaurant-is.jpg?alt=media&token=27213c73-2e0a-4c0c-8682-c9bd17a35eac"
      ],
      description: null),
  Activity(
      aid: Uuid().v4(),
      popularity: 5,
      type: 'restaurant',
      price: '\$\$',
      name: "Liquid Ginger",
      tag: 'Asian fusion restaurant',
      address: '101 SE 2nd Pl',
      images: [
        "https://firebasestorage.googleapis.com/v0/b/jungle-2a886.appspot.com/o/activities%2F67706528_2219288854850079_7134618394430537728_n.jpg?alt=media&token=75d6de3f-9272-409a-af92-f4a19b0242c5"
      ],
      description: null),
];

List<DropdownMenuItem<String>> schools = [
  DropdownMenuItem(
    child: Text('University of Florida'),
    value: 'University of Florida',
  ),
  DropdownMenuItem(
    child: Text('University of Florida'),
    value: 'University of Florida',
  ),
  DropdownMenuItem(
    child: Text('University of Florida'),
    value: 'University of Florida',
  ),
];
