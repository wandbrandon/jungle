import 'package:jungle/models/models.dart';

class Users {
  static get initUsers => <User>[
        User(
            name: "Obama",
            age: 21,
            live: "Gainesville, FL",
            bio: "POTUS baby, black btw. 6 foot",
            work: "Ex President of the US",
            edu: "eduversity of Harvard",
            from: "Hawaii",
            images: [
              "https://i.insider.com/5fbeabe8037cbd00186125c7?width=1000&format=jpeg&auto=webp",
              "https://i.insider.com/5fbeabe8037cbd00186125c7?width=1000&format=jpeg&auto=webp",
              "https://i.insider.com/5fbeabe8037cbd00186125c7?width=1000&format=jpeg&auto=webp",
            ]),
        User(
            name: 'Jeff',
            age: 21,
            live: "Gainesville, FL",
            bio: "I literally rape children",
            work: "Nasty Pedophile",
            edu: "eduversity of Pedophilia",
            from: "Fountain of Youth, NY",
            images: [
              'https://i.guim.co.uk/img/media/25aec7f2db66a5f8cf2ee3da96c361b3a105bf8c/0_0_2347_2346/master/2347.jpg?width=700&quality=85&auto=format&fit=max&s=eca2838686532ecbc1a0ec55b080b672',
              'https://i.guim.co.uk/img/media/25aec7f2db66a5f8cf2ee3da96c361b3a105bf8c/0_0_2347_2346/master/2347.jpg?width=700&quality=85&auto=format&fit=max&s=eca2838686532ecbc1a0ec55b080b672',
              'https://i.guim.co.uk/img/media/25aec7f2db66a5f8cf2ee3da96c361b3a105bf8c/0_0_2347_2346/master/2347.jpg?width=700&quality=85&auto=format&fit=max&s=eca2838686532ecbc1a0ec55b080b672',
            ]),
        User(
          name: 'Brad',
          images: [
            'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/gettyimages-74218931-1576171955.jpg',
            'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/gettyimages-74218931-1576171955.jpg',
            'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/gettyimages-74218931-1576171955.jpg',
          ],
          age: 21,
          live: "Gainesville, FL",
          bio: "I'm an THE Brad Pitt",
          work: "Famous Actor",
          edu: "eduversity of God ",
          from: "Austin, TX",
        ),
        User(
          name: 'Donald',
          images: [
            'https://i.insider.com/57b5bea1db5ce9b20f8b7737?width=987&format=jpeg',
            'https://i.insider.com/57b5bea1db5ce9b20f8b7737?width=987&format=jpeg',
            'https://i.insider.com/57b5bea1db5ce9b20f8b7737?width=987&format=jpeg',
          ],
          age: 21,
          live: "Gainesville, FL",
          bio:
              "pls vote for me I need it, I love to make fun of the news, I love to lie to the press, and I also enjoy having my wife's boyfriend take me out on trips.",
          work: "Ex President of the US",
          edu: "eduversity of Chicago",
          from: "New York City, NY",
        ),
        User(
          name: 'Bill',
          images: [
            'https://static.politico.com/8f/0c/5f5df7c945ec812c412ecc390bf3/clinton-3.jpg',
            'https://static.politico.com/8f/0c/5f5df7c945ec812c412ecc390bf3/clinton-3.jpg',
            'https://static.politico.com/8f/0c/5f5df7c945ec812c412ecc390bf3/clinton-3.jpg',
          ],
          age: 21,
          live: "Gainesville, FL",
          bio: "I did not have relations with that woman",
          work: "Absolute Womanizer",
          edu: "eduversity of Harvard",
          from: "Arkansas, AR",
        ),
        User(
          name: 'Joe',
          images: [
            'https://static01.nyt.com/images/2020/09/18/us/politics/00young-biden/00young-biden-videoSixteenByNineJumbo1600.jpg',
            'https://static01.nyt.com/images/2020/09/18/us/politics/00young-biden/00young-biden-videoSixteenByNineJumbo1600.jpg',
            'https://static01.nyt.com/images/2020/09/18/us/politics/00young-biden/00young-biden-videoSixteenByNineJumbo1600.jpg'
          ],
          age: 21,
          live: "Gainesville, FL",
          bio: "where am I? what app is this? hey did we win the election?",
          work: "President of the US",
          edu: "eduversity of Harvard",
          from: "Rhode Island, RI",
        ),
      ];
}

// // FAVORITE CONTACTS
// List<User> favorites = [joe, donald, bill, brad, jeff];

// List<Message> joeMessages = [
//   Message(
//     id: 5,
//     time: '5:30 PM',
//     text:
//         "What the fuck did you just fucking say about me, you little bitch? I'll have you know I graduated top of my class in the Navy Seals, and I've been involved in numerous secret raids on Al-Quaeda, and I have over 300 confirmed kills. I am trained in gorilla warfare and I'm the top sniper in the entire US armed forces. You are nothing to me but just another target. I will wipe you the fuck out with precision the likes of which has never been seen before on this Earth, mark my fucking words. You think you can get away with saying that shit to me over the Internet? Think again, fucker. As we speak I am contacting my secret network of spies across the USA and your IP is being traced right now so you better prepare for the storm, maggot. The storm that wipes out the pathetic little thing you call your life. You're fucking dead, kid. I can be anywhere, anytime, and I can kill you in over seven hundred ways, and that's just with my bare hands. Not only am I extensively trained in unarmed combat, but I have access to the entire arsenal of the eduted States Marine Corps and I will use it to its full extent to wipe your miserable ass off the face of the continent, you little shit. If only you could have known what unholy retribution your little 'clever' comment was about to bring down upon you, maybe you would have held your fucking tongue. But you couldn't, you didn't, and now you're paying the price, you goddamn idiot. I will shit fury all over you and you will drown in it. You're fucking dead, kiddo.",
//     isLiked: true,
//     unread: true,
//   ),
//   Message(
//     id: 0,
//     time: '4:30 PM',
//     text: 'like this is kinda serious',
//     isLiked: false,
//     unread: true,
//   ),
//   Message(
//     id: 0,
//     time: '3:45 PM',
//     text:
//         'Dude, do you have fucking dementia? ur the president of the eduted states',
//     isLiked: false,
//     unread: true,
//   ),
//   Message(
//     id: 5,
//     time: '3:15 PM',
//     text: "I'm so tired...",
//     isLiked: true,
//     unread: true,
//   ),
//   Message(
//     id: 5,
//     time: '2:30 PM',
//     text: "Who's this??",
//     isLiked: false,
//     unread: true,
//   ),
//   Message(
//     id: 0,
//     time: '2:00 PM',
//     text: 'Hey you did it Joe! You are the new POTUS!!',
//     isLiked: false,
//     unread: true,
//   ),
// ];

// List<Message> donaldMessages = [
//   Message(
//     id: 3,
//     time: '5:30 PM',
//     text: 'like fuck',
//     isLiked: true,
//     unread: true,
//   ),
//   Message(
//     id: 3,
//     time: '5:30 PM',
//     text: 'dude you are fucking black',
//     isLiked: true,
//     unread: true,
//   ),
//   Message(
//     id: 0,
//     time: '4:30 PM',
//     text: 'dude you are always on my case, honestly kinda annoying',
//     isLiked: false,
//     unread: true,
//   ),
//   Message(
//     id: 3,
//     time: '3:45 PM',
//     text: 'whatever bro, get off my case',
//     isLiked: false,
//     unread: true,
//   ),
//   Message(
//     id: 0,
//     time: '3:15 PM',
//     text: 'Sounds like someone is insecure they lost',
//     isLiked: true,
//     unread: true,
//   ),
//   Message(
//     id: 0,
//     time: '2:30 PM',
//     text: 'Yikes man',
//     isLiked: false,
//     unread: true,
//   ),
//   Message(
//     id: 3,
//     time: '2:00 PM',
//     text:
//         'Hey just wanted to call u out. I was a better prez than you will ever be.',
//     isLiked: false,
//     unread: true,
//   ),
// ];

// List<Message> billMessages = [
//   Message(
//     id: 3,
//     time: '5:30 PM',
//     text: 'hey u coming to jeffs party?',
//     isLiked: false,
//     unread: true,
//   ),
// ];

// List<Message> jeffMessages = [
//   Message(
//     id: 3,
//     time: '5:30 PM',
//     text: 'Dude im in so much trouble bro',
//     isLiked: false,
//     unread: true,
//   ),
//   Message(
//     id: 3,
//     time: '5:30 PM',
//     text: 'i think im gonna have to kms',
//     isLiked: false,
//     unread: true,
//   ),
// ];

// List<Message> bradMessages = [
//   Message(
//     id: 0,
//     time: '5:30 PM',
//     text: 'Hey there handsome',
//     isLiked: false,
//     unread: true,
//   ),
// ];

final List<Activity> bars = [
  Activity(
      //home: LatLng(29.650719185666006, -82.32526474368572),
      name: "Downtown Fats",
      images: [
        "https://scontent-atl3-1.cdninstagram.com/v/t51.2885-15/e35/s1080x1080/121574849_384181839419847_8553776110686228923_n.jpg?_nc_ht=scontent-atl3-1.cdninstagram.com&_nc_cat=103&_nc_ohc=fF5SLO6JOrIAX8m5NjK&tp=15&oh=33c28c42c8232c1989186b8d7455afa2&oe=5FDC8790"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever."),
  Activity(
      name: "JJ's Tavern",
      //home: LatLng(29.652641653369997, -82.34509681484927),
      images: [
        "https://myareanetwork-photos.s3.amazonaws.com/editorphotos/f/38493_1574714550.jpg"
      ],
      description:
          "I could not hate a bar more than jjs tavern, there is pure noise pollution and hell in here. All the women are hideous and honestly you are too."),
  Activity(
      name: "Fat Daddy's",
      //home: LatLng(29.65263232957408, -82.34513973019457),
      images: [
        "https://scontent-atl3-1.cdninstagram.com/v/t51.2885-15/e35/s1080x1080/121411915_944097126001512_4463546720263959708_n.jpg?_nc_ht=scontent-atl3-1.cdninstagram.com&_nc_cat=100&_nc_ohc=pRHU5sPk0FkAX82_vvJ&tp=15&oh=06445da11563b6838dd150da72ffba28&oe=5FD986E2"
      ],
      description:
          "Enjoy having nothing but beer soaked pants and lonely masturbation at this bar. You will literally waste your time. Nuff said."),
  Activity(
      name: "White Buffalo",
      //home: LatLng(29.650761157551646, -82.32477522834031),
      images: [
        "https://scontent-atl3-1.cdninstagram.com/v/t51.2885-15/e35/p1080x1080/102404482_957109758064830_6368971491856859158_n.jpg?_nc_ht=scontent-atl3-1.cdninstagram.com&_nc_cat=106&_nc_ohc=iKFa090GocUAX-cDbLc&tp=19&oh=dae46dc95f8270cc4e2481999e21d530&oe=5FD8FA4A"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever."),
];

final List<Activity> rests = [
  Activity(
      count: 462,
      name: "Dragon Fly",
      location: 'Gainesville',
      images: [
        "https://cdna.artstation.com/p/assets/images/images/017/715/718/original/liliana-pita-pixel-city-water-try-again.gif?1557080526"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever."),
  Activity(
      count: 347,
      name: "Top Ramen",
      location: 'Gainesville',
      images: [
        "https://images.squarespace-cdn.com/content/v1/5e29fdb6a671454c6d456f61/1581028262182-1N2D4IRJBD2M3QE3HSIR/ke17ZwdGBToddI8pDm48kOSmCgFW3fviOOJsRBidWZ4UqsxRUqqbr1mOJYKfIPR7LoDQ9mXPOjoJoqy81S2I8N_N4V1vUb5AoIIIbLZhVYxCRW4BPu10St3TBAUQYVKcI1yTXeFqGF93KQF5Bi56MCrOfSQCtPWQj_XK4nEb6uzrrGCPYt1MoEE8SyoSeUO8/MVuong_Project-1_Final.gif?format=1500w"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever."),
  Activity(
      count: 90,
      name: "The Top",
      location: 'Gainesville',
      images: [
        "https://i.pinimg.com/originals/12/a1/a1/12a1a1fa165b268419d22321dd519795.gif"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever.")
];
