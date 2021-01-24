import 'package:jungle/models/models.dart';
import 'package:uuid/uuid.dart';

final List<Activity> bars = [
  Activity(
      aid: Uuid().v4(),
      price: '\$\$',
      name: "Downtown Fats",
      tag: 'College Bar/Club',
      address: '1702 W University Ave Suite A1, Gainesville, FL 32603',
      images: [
        "https://snworksceo.imgix.net/ufa/0d425f55-11be-44cd-8038-337669052478.sized-1000x1000.jpg?w=800&dpr=2&ar=16%3A9&fit=crop&crop=faces"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever."),
  Activity(
      aid: Uuid().v4(),
      price: '\$\$',
      name: "JJ's Tavern",
      tag: 'Traditional American',
      address: '1702 W University Ave Suite G, Gainesville, FL 32603',
      images: [
        "https://myareanetwork-photos.s3.amazonaws.com/editorphotos/f/38493_1574714550.jpg"
      ],
      description:
          "I could not hate a bar more than jjs tavern, there is pure noise pollution and hell in here. All the women are hideous and honestly you are too."),
  Activity(
      aid: Uuid().v4(),
      price: '\$\$',
      name: "Tatu",
      tag: 'Bar and grill',
      address: '1702 W University Ave J, Gainesville, FL 32603',
      images: [
        "https://snworksceo.imgix.net/ufa/b056709c-bf31-4107-819b-e22a160909bd.sized-1000x1000.jpg?w=800&dpr=2&ar=16%3A9&fit=crop&crop=faces"
      ],
      description:
          "Enjoy having nothing but beer soaked pants and lonely masturbation at this bar. You will literally waste your time. Nuff said."),
  Activity(
      aid: Uuid().v4(),
      price: '\$\$',
      name: "Downtown Fats",
      tag: 'College Bar',
      address: '112 S Main St, Gainesville, FL 32601',
      images: [
        "https://www.gainesville.com/storyimage/LK/20171018/NEWS/171017780/AR/0/AR-171017780.jpg"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever."),
  Activity(
      aid: Uuid().v4(),
      price: '\$\$',
      name: "Simon's",
      tag: 'Night club',
      address: '8 S Main St, Gainesville, FL 32601',
      images: [
        "https://www.gainesville.com/storyimage/LK/20171018/NEWS/171017780/AR/0/AR-171017780.jpg"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever."),
  Activity(
      aid: Uuid().v4(),
      price: '\$\$',
      name: "Grog",
      tag: 'Bar & Grill',
      address: '1718 W University Ave, Gainesville, FL 32603',
      images: [
        "https://www.gainesville.com/storyimage/LK/20171018/NEWS/171017780/AR/0/AR-171017780.jpg"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever."),
  Activity(
      aid: Uuid().v4(),
      price: '\$',
      name: "Salty Dog Saloon",
      tag: 'College Bar',
      address: '1712 W University Ave, Gainesville, FL 32603',
      images: [
        "https://www.gainesville.com/storyimage/LK/20171018/NEWS/171017780/AR/0/AR-171017780.jpg"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever."),
  Activity(
      aid: Uuid().v4(),
      price: '\$\$',
      name: "Social",
      tag: 'Sports Bar',
      address: '1728 W University Ave, Gainesville, FL 32603',
      images: [
        "https://www.gainesville.com/storyimage/LK/20171018/NEWS/171017780/AR/0/AR-171017780.jpg"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever."),
  Activity(
      aid: Uuid().v4(),
      price: '\$',
      name: "Rowdy Reptile",
      tag: 'College Bar',
      address: '1702 W University Ave Suite A1, Gainesville, FL 32603',
      images: [
        "https://www.gainesville.com/storyimage/LK/20171018/NEWS/171017780/AR/0/AR-171017780.jpg"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever."),
  Activity(
      aid: Uuid().v4(),
      price: '\$\$',
      name: "Night Club",
      tag: 'College Bar',
      address: '18 W University Ave, Gainesville, FL 32601',
      images: [
        "https://www.gainesville.com/storyimage/LK/20171018/NEWS/171017780/AR/0/AR-171017780.jpg"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever."),
  Activity(
      aid: Uuid().v4(),
      price: '\$',
      name: "Lit at Midtown",
      tag: 'College Bar',
      address: '1120 W University Ave, Gainesville, FL 32601',
      images: [
        "https://www.gainesville.com/storyimage/LK/20171018/NEWS/171017780/AR/0/AR-171017780.jpg"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever."),
  Activity(
      aid: Uuid().v4(),
      price: '\$',
      name: "White Buffalo",
      tag: 'College Bar',
      address: '111 S Main St, Gainesville, FL 32601',
      images: [
        "https://www.gainesville.com/storyimage/LK/20171018/NEWS/171017780/AR/0/AR-171017780.jpg"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever."),
];

final List<Activity> rests = [
  Activity(
      aid: Uuid().v4(),
      price: '\$\$\$',
      name: "Dragon Fly",
      tag: 'Sushi restaurant',
      address: '201 SE 2nd Ave #104, Gainesville, FL 32601',
      images: [
        "https://cdna.artstation.com/p/assets/images/images/017/715/718/original/liliana-pita-pixel-city-water-try-again.gif?1557080526"
      ],
      description:
          "Contemporary izakaya featuring tapas-style Japanese pub fare plus an assortment of sake."),
  Activity(
      aid: Uuid().v4(),
      price: '\$\$',
      name: "Crane Ramen",
      address: '16 SW 1 Ave, Gainesville, FL 32601',
      images: [
        "https://images.squarespace-cdn.com/content/v1/5e29fdb6a671454c6d456f61/1581028262182-1N2D4IRJBD2M3QE3HSIR/ke17ZwdGBToddI8pDm48kOSmCgFW3fviOOJsRBidWZ4UqsxRUqqbr1mOJYKfIPR7LoDQ9mXPOjoJoqy81S2I8N_N4V1vUb5AoIIIbLZhVYxCRW4BPu10St3TBAUQYVKcI1yTXeFqGF93KQF5Bi56MCrOfSQCtPWQj_XK4nEb6uzrrGCPYt1MoEE8SyoSeUO8/MVuong_Project-1_Final.gif?format=1500w"
      ],
      description:
          "Hip Japanese locale crafting ramen made with area-sourced ingredients, plus unique cocktails."),
  Activity(
      aid: Uuid().v4(),
      price: '\$\$',
      name: "The Top",
      tag: 'American Restuarant',
      address: '30 N Main St, Gainesville, FL 32601',
      images: [
        "https://i.pinimg.com/originals/12/a1/a1/12a1a1fa165b268419d22321dd519795.gif"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever."),
  Activity(
      aid: Uuid().v4(),
      price: '\$',
      name: "La Tienda",
      tag: 'Mexican Restaurant',
      address: '2204 SW 13th St, Gainesville, FL 32608',
      images: [
        "https://static01.nyt.com/images/2013/02/14/fashion/14ZGIFS1/14ZGIFS1-articleLarge-v4.gif?quality=75&auto=webp&disable=upscale"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever."),
  Activity(
      aid: Uuid().v4(),
      price: '\$',
      name: "Adam's Ribs",
      tag: 'Barbecue Restaurant',
      address: '1515 SW 13th St, Gainesville, FL 32608',
      images: ["https://thumbs.gfycat.com/AnchoredBouncyKob-small.gif"],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever."),
  Activity(
      aid: Uuid().v4(),
      price: '\$\$\$\$',
      name: "Peter Grif",
      tag: 'Family Guy',
      images: [
        "https://mir-s3-cdn-cf.behance.net/project_modules/disp/3c3e4e73094115.5bfe66e5ca411.gif"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever.")
];
