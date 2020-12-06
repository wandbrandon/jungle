import 'package:jungle/models/models.dart';

final User currentUser = User(
  id: 0,
  name: "Obama",
  age: 21,
  location: "Gainesville, FL",
  bio: "POTUS baby, black btw. 6 foot",
  work: "Ex President of the US",
  uni: "University of Harvard",
  hometown: "Hawaii",
  imageUrl:
      "https://i.insider.com/5fbeabe8037cbd00186125c7?width=1000&format=jpeg&auto=webp",
  messages: joeMessages,
);
final User jeff = User(
  id: 1,
  name: 'Jeff',
  age: 21,
  location: "Gainesville, FL",
  bio: "I literally rape children",
  work: "Nasty Pedophile",
  uni: "University of Pedophilia",
  hometown: "Fountain of Youth, NY",
  messages: jeffMessages,
  imageUrl:
      'https://i.guim.co.uk/img/media/25aec7f2db66a5f8cf2ee3da96c361b3a105bf8c/0_0_2347_2346/master/2347.jpg?width=700&quality=85&auto=format&fit=max&s=eca2838686532ecbc1a0ec55b080b672',
);
final User brad = User(
  id: 2,
  name: 'Brad',
  imageUrl:
      'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/gettyimages-74218931-1576171955.jpg',
  age: 21,
  location: "Gainesville, FL",
  bio: "I'm an THE Brad Pitt",
  work: "Famous Actor",
  uni: "University of God ",
  hometown: "Austin, TX",
  messages: bradMessages,
);
final User donald = User(
  id: 3,
  name: 'Donald',
  imageUrl:
      'https://i.insider.com/57b5bea1db5ce9b20f8b7737?width=987&format=jpeg',
  age: 21,
  location: "Gainesville, FL",
  bio:
      "pls vote for me I need it, I love to make fun of the news, I love to lie to the press, and I also enjoy having my wife's boyfriend take me out on trips.",
  work: "Ex President of the US",
  uni: "University of Chicago",
  hometown: "New York City, NY",
  messages: donaldMessages,
);
final User bill = User(
  id: 4,
  name: 'Bill',
  imageUrl:
      'https://static.politico.com/8f/0c/5f5df7c945ec812c412ecc390bf3/clinton-3.jpg',
  age: 21,
  location: "Gainesville, FL",
  bio: "I did not have relations with that woman",
  work: "Absolute Womanizer",
  uni: "University of Harvard",
  hometown: "Arkansas, AR",
  messages: billMessages,
);
final User joe = User(
  id: 5,
  name: 'Joe',
  imageUrl:
      'https://static01.nyt.com/images/2020/09/18/us/politics/00young-biden/00young-biden-videoSixteenByNineJumbo1600.jpg',
  age: 21,
  location: "Gainesville, FL",
  bio: "where am I? what app is this? hey did we win the election?",
  work: "President of the US",
  uni: "University of Harvard",
  hometown: "Rhode Island, RI",
  messages: joeMessages,
);

// FAVORITE CONTACTS
List<User> favorites = [joe, donald, bill, brad, jeff];

List<Message> joeMessages = [
  Message(
    id: 5,
    time: '5:30 PM',
    text:
        "What the fuck did you just fucking say about me, you little bitch? I'll have you know I graduated top of my class in the Navy Seals, and I've been involved in numerous secret raids on Al-Quaeda, and I have over 300 confirmed kills. I am trained in gorilla warfare and I'm the top sniper in the entire US armed forces. You are nothing to me but just another target. I will wipe you the fuck out with precision the likes of which has never been seen before on this Earth, mark my fucking words. You think you can get away with saying that shit to me over the Internet? Think again, fucker. As we speak I am contacting my secret network of spies across the USA and your IP is being traced right now so you better prepare for the storm, maggot. The storm that wipes out the pathetic little thing you call your life. You're fucking dead, kid. I can be anywhere, anytime, and I can kill you in over seven hundred ways, and that's just with my bare hands. Not only am I extensively trained in unarmed combat, but I have access to the entire arsenal of the United States Marine Corps and I will use it to its full extent to wipe your miserable ass off the face of the continent, you little shit. If only you could have known what unholy retribution your little 'clever' comment was about to bring down upon you, maybe you would have held your fucking tongue. But you couldn't, you didn't, and now you're paying the price, you goddamn idiot. I will shit fury all over you and you will drown in it. You're fucking dead, kiddo.",
    isLiked: true,
    unread: true,
  ),
  Message(
    id: 0,
    time: '4:30 PM',
    text: 'like this is kinda serious',
    isLiked: false,
    unread: true,
  ),
  Message(
    id: 0,
    time: '3:45 PM',
    text:
        'Dude, do you have fucking dementia? ur the president of the united states',
    isLiked: false,
    unread: true,
  ),
  Message(
    id: 5,
    time: '3:15 PM',
    text: "I'm so tired...",
    isLiked: true,
    unread: true,
  ),
  Message(
    id: 5,
    time: '2:30 PM',
    text: "Who's this??",
    isLiked: false,
    unread: true,
  ),
  Message(
    id: 0,
    time: '2:00 PM',
    text: 'Hey you did it Joe! You are the new POTUS!!',
    isLiked: false,
    unread: true,
  ),
];

List<Message> donaldMessages = [
  Message(
    id: 3,
    time: '5:30 PM',
    text: 'like fuck',
    isLiked: true,
    unread: true,
  ),
  Message(
    id: 3,
    time: '5:30 PM',
    text: 'dude you are fucking black',
    isLiked: true,
    unread: true,
  ),
  Message(
    id: 0,
    time: '4:30 PM',
    text: 'dude you are always on my case, honestly kinda annoying',
    isLiked: false,
    unread: true,
  ),
  Message(
    id: 3,
    time: '3:45 PM',
    text: 'whatever bro, get off my case',
    isLiked: false,
    unread: true,
  ),
  Message(
    id: 0,
    time: '3:15 PM',
    text: 'Sounds like someone is insecure they lost',
    isLiked: true,
    unread: true,
  ),
  Message(
    id: 0,
    time: '2:30 PM',
    text: 'Yikes man',
    isLiked: false,
    unread: true,
  ),
  Message(
    id: 3,
    time: '2:00 PM',
    text:
        'Hey just wanted to call u out. I was a better prez than you will ever be.',
    isLiked: false,
    unread: true,
  ),
];

List<Message> billMessages = [
  Message(
    id: 3,
    time: '5:30 PM',
    text: 'hey u coming to jeffs party?',
    isLiked: false,
    unread: true,
  ),
];

List<Message> jeffMessages = [
  Message(
    id: 3,
    time: '5:30 PM',
    text: 'Dude im in so much trouble bro',
    isLiked: false,
    unread: true,
  ),
  Message(
    id: 3,
    time: '5:30 PM',
    text: 'i think im gonna have to kms',
    isLiked: false,
    unread: true,
  ),
];

List<Message> bradMessages = [
  Message(
    id: 0,
    time: '5:30 PM',
    text: 'Hey there handsome',
    isLiked: false,
    unread: true,
  ),
];

final List<Food> bars = [
  Food(
      id: 0,
      name: "Downtown Fats",
      imageUrls: [
        "https://scontent-atl3-1.cdninstagram.com/v/t51.2885-15/e35/s1080x1080/121574849_384181839419847_8553776110686228923_n.jpg?_nc_ht=scontent-atl3-1.cdninstagram.com&_nc_cat=103&_nc_ohc=fF5SLO6JOrIAX8m5NjK&tp=15&oh=33c28c42c8232c1989186b8d7455afa2&oe=5FDC8790"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever."),
  Food(
      id: 1,
      name: "JJ's Tavern",
      imageUrls: [
        "https://myareanetwork-photos.s3.amazonaws.com/editorphotos/f/38493_1574714550.jpg"
      ],
      description:
          "I could not hate a bar more than jjs tavern, there is pure noise pollution and hell in here. All the women are hideous and honestly you are too."),
  Food(
      id: 2,
      name: "Fat Daddy's",
      imageUrls: [
        "https://scontent-atl3-1.cdninstagram.com/v/t51.2885-15/e35/s1080x1080/121411915_944097126001512_4463546720263959708_n.jpg?_nc_ht=scontent-atl3-1.cdninstagram.com&_nc_cat=100&_nc_ohc=pRHU5sPk0FkAX82_vvJ&tp=15&oh=06445da11563b6838dd150da72ffba28&oe=5FD986E2"
      ],
      description:
          "Enjoy having nothing but beer soaked pants and lonely masturbation at this bar. You will literally waste your time. Nuff said."),
  Food(
      id: 3,
      name: "White Buffalo",
      imageUrls: [
        "https://scontent-atl3-1.cdninstagram.com/v/t51.2885-15/e35/p1080x1080/102404482_957109758064830_6368971491856859158_n.jpg?_nc_ht=scontent-atl3-1.cdninstagram.com&_nc_cat=106&_nc_ohc=iKFa090GocUAX-cDbLc&tp=19&oh=dae46dc95f8270cc4e2481999e21d530&oe=5FD8FA4A"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever."),
];

final List<Food> rests = [
  Food(
      id: 0,
      name: "Dragon Fly",
      imageUrls: [
        "https://scontent-atl3-1.xx.fbcdn.net/v/t1.0-9/67915655_110057167008743_1303072358684164096_n.jpg?_nc_cat=104&ccb=2&_nc_sid=8bfeb9&_nc_ohc=FiKFEZAdETIAX9HlVXM&_nc_ht=scontent-atl3-1.xx&oh=ae2397882171f1c36ccc54a6f5cb66a0&oe=5FD411CB"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever."),
  Food(
      id: 0,
      name: "Piesanos",
      imageUrls: [
        "https://scontent-atl3-1.xx.fbcdn.net/v/t1.0-9/67915655_110057167008743_1303072358684164096_n.jpg?_nc_cat=104&ccb=2&_nc_sid=8bfeb9&_nc_ohc=FiKFEZAdETIAX9HlVXM&_nc_ht=scontent-atl3-1.xx&oh=ae2397882171f1c36ccc54a6f5cb66a0&oe=5FD411CB"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever."),
  Food(
      id: 0,
      name: "The Top",
      imageUrls: [
        "https://scontent-atl3-1.xx.fbcdn.net/v/t1.0-9/67915655_110057167008743_1303072358684164096_n.jpg?_nc_cat=104&ccb=2&_nc_sid=8bfeb9&_nc_ohc=FiKFEZAdETIAX9HlVXM&_nc_ht=scontent-atl3-1.xx&oh=ae2397882171f1c36ccc54a6f5cb66a0&oe=5FD411CB"
      ],
      description:
          "This bar absolutely sucks, there are bitches and puke everywhere with no attention to anything at all. Worst experience ever.")
];
