import { Genre } from '@prisma/client';

export const books = [
  {
    isbn: '9780385534260',
    title: 'The Wager: A Tale of Shipwreck, Mutiny and Murder',
    author: 'David Grann',
    publishedDate: new Date('2023-04-18T00:00:00.000Z'),
    description:
      "The riveting story of a British shipwreck in the 18th century that led to a harrowing fight for survival, a mutiny, and a trial upon the survivors' return, revealing the limits of human endurance.",
    coverUrl:
      'https://storage.googleapis.com/duolibros-32a86.appspot.com/book-covers%2F1730329152012_9780385534260',
    genre: Genre.HISTORY,
  },
  {
    isbn: '9780593239919',
    title: 'Poverty, By America',
    author: 'Matthew Desmond',
    publishedDate: new Date('2023-03-21T00:00:00.000Z'),
    description:
      'A critical exploration of the systems that keep poverty alive in America, showing how everyday choices and policies benefit some at the expense of many, urging readers to confront their role in systemic inequality.',
    coverUrl:
      'https://storage.googleapis.com/duolibros-32a86.appspot.com/book-covers%2F1730329209515_9780593239919',
    genre: Genre.HISTORY,
  },
  {
    isbn: '9780593321201',
    title: 'Tomorrow, and Tomorrow, and Tomorrow',
    author: 'Gabrielle Zevin',
    publishedDate: new Date('2023-07-10T00:00:00.000Z'),
    description:
      'In this novel, childhood friends Sam and Sadie reconnect in college and discover a shared passion for creating video games. Their journey, from being idealistic young developers to successful entrepreneurs, unfolds over decades and against a backdrop of love, betrayal, and forgiveness. As they rise to fame and face industry pressures, they must navigate the complexities of friendship, ambition, and their own creative visions. This story offers a nuanced exploration of how relationships evolve under the weight of success and explores the enduring question of what it means to play, create, and collaborate.',
    coverUrl:
      'https://storage.googleapis.com/duolibros-32a86.appspot.com/book-covers%2F1730328998118_9780593321201',
    genre: Genre.FICTION,
  },
  {
    isbn: '9780063251922',
    title: 'Demon Copperhead',
    author: 'Barbara Kingsolver',
    publishedDate: new Date('2022-10-18T00:00:00.000Z'),
    description:
      "Inspired by 'David Copperfield,' Kingsolver crafts a gripping tale set in the Appalachian mountains, following the life of Damon Fields, nicknamed Demon Copperhead. Orphaned at a young age, Demon faces the harsh realities of rural poverty, an opioid crisis, and foster care, but his vibrant spirit and unbreakable will offer glimpses of hope. As he battles addiction, homelessness, and systemic failure, Demon's resilience and innate intelligence shine through, revealing the strength of the human spirit. This is a timely and deeply moving portrayal of forgotten communities and the generational cycles of hardship.",
    coverUrl:
      'https://storage.googleapis.com/duolibros-32a86.appspot.com/book-covers%2F1730329039298_9780063251922',
    genre: Genre.HISTORY,
  },
  {
    isbn: '9780593243735',
    title: 'Hello Beautiful',
    author: 'Ann Napolitano',
    publishedDate: new Date('2023-03-14T23:05:16.590Z'),
    description:
      "Set against the backdrop of a close-knit Italian American family, this novel traces the lives of four sisters whose dreams and relationships are tested by betrayal and tragedy. As they grow from childhood into adulthood, their bonds are both their greatest comfort and most complex challenge. When a long-buried secret comes to light, they must each confront painful truths and decide if they can forgive. 'Hello Beautiful' is a poignant examination of family loyalty, resilience, and the choices that define us, echoing classic literary themes of love, forgiveness, and self-discovery.",
    coverUrl:
      'https://storage.googleapis.com/duolibros-32a86.appspot.com/book-covers%2F1730330125782_9780593243735',
    genre: Genre.ROMANCE,
  },
  {
    isbn: '9780593593809',
    title: 'Spare',
    author: 'Prince Harry',
    publishedDate: new Date('2023-01-11T02:57:49.031Z'),
    description:
      "In this intensely personal memoir, Prince Harry reveals his life beyond the public gaze, from childhood trauma to his departure from the British monarchy. He reflects on the loss of his mother, Princess Diana, and the subsequent struggles he faced, including grappling with mental health issues, finding love, and becoming a father. Harry opens up about his journey toward personal freedom, offering rare insights into the challenges of royal life. 'Spare' is a candid and compassionate exploration of grief, identity, and the pursuit of happiness beyond privilege and duty.",
    coverUrl:
      'https://storage.googleapis.com/duolibros-32a86.appspot.com/book-covers%2F1730602773950_9780593593809',
    genre: Genre.BIOGRAPHY,
  },
  {
    isbn: '9780747532699',
    title: "Harry Potter and the Philosopher's Stone",
    author: 'J.K. Rowling',
    publishedDate: new Date('1997-06-26T00:00:00.000Z'),
    description:
      'The story of a young wizard, Harry Potter, who discovers his magical heritage and begins his journey at Hogwarts School of Witchcraft and Wizardry.',
    coverUrl:
      'https://storage.googleapis.com/duolibros-32a86.appspot.com/book-covers%5C1732649970148_11',
    genre: Genre.FANTASY,
  },
  {
    isbn: '9780747538493',
    title: 'Harry Potter and the Chamber of Secrets',
    author: 'J.K. Rowling',
    publishedDate: new Date('1998-07-02T00:00:00.000Z'),
    description:
      "Harry's second year at Hogwarts is marked by the opening of the Chamber of Secrets, leading to mysterious attacks on students and dark secrets being unveiled.",
    coverUrl:
      'https://storage.googleapis.com/duolibros-32a86.appspot.com/book-covers%5C1732649996706_12',
    genre: Genre.FANTASY,
  },
  {
    isbn: '9780747542155',
    title: 'Harry Potter and the Prisoner of Azkaban',
    author: 'J.K. Rowling',
    publishedDate: new Date('1999-07-08T00:00:00.000Z'),
    description:
      'In his third year at Hogwarts, Harry uncovers truths about his past and faces the escaped prisoner Sirius Black, who is believed to be hunting him.',
    coverUrl:
      'https://storage.googleapis.com/duolibros-32a86.appspot.com/book-covers%5C1732650014331_13',
    genre: Genre.FANTASY,
  },
  {
    isbn: '9780747546245',
    title: 'Harry Potter and the Goblet of Fire',
    author: 'J.K. Rowling',
    publishedDate: new Date('2000-07-08T00:00:00.000Z'),
    description:
      'Harry is unexpectedly entered into the dangerous Triwizard Tournament, facing life-threatening tasks and uncovering dark forces at play.',
    coverUrl:
      'https://storage.googleapis.com/duolibros-32a86.appspot.com/book-covers%5C1732650110970_15',
    genre: Genre.FANTASY,
  },
  {
    isbn: '9780747551003',
    title: 'Harry Potter and the Order of the Phoenix',
    author: 'J.K. Rowling',
    publishedDate: new Date('2003-06-21T00:00:00.000Z'),
    description:
      'Harry and his friends form a secret group to fight against the rising threat of Voldemort while battling the oppressive rule of Dolores Umbridge at Hogwarts.',
    coverUrl:
      'https://storage.googleapis.com/duolibros-32a86.appspot.com/book-covers%5C1732649916853_00',
    genre: Genre.FANTASY,
  },
  {
    isbn: '9780143127741',
    title: 'The Wright Brothers',
    author: 'David McCullough',
    publishedDate: new Date('2015-05-05T00:00:00.000Z'),
    description:
      'The dramatic story-behind-the-story about the courageous brothers who taught the world how to fly: Wilbur and Orville Wright.',
    coverUrl:
      'https://storage.googleapis.com/duolibros-32a86.appspot.com/book-covers%2F1732991341580_9780143127741',
    genre: Genre.HISTORY,
  },
  {
    isbn: '9780143127742',
    title: 'The Immortal Life of Henrietta Lacks',
    author: 'Rebecca Skloot',
    publishedDate: new Date('2010-02-02T00:00:00.000Z'),
    description:
      'The story of Henrietta Lacks and the immortal cell line, known as HeLa, that came from her cervical cancer cells in 1951.',
    coverUrl:
      'https://storage.googleapis.com/duolibros-32a86.appspot.com/book-covers%2F1732991342147_9780143127742',
    genre: Genre.HISTORY,
  },
  {
    isbn: '9780143127743',
    title: 'The Night Circus',
    author: 'Erin Morgenstern',
    publishedDate: new Date('2011-09-13T00:00:00.000Z'),
    description:
      'A magical realism novel about a mysterious circus that appears without warning and is only open at night.',
    coverUrl:
      'https://storage.googleapis.com/duolibros-32a86.appspot.com/book-covers%2F1732991340807_9780143127743',
    genre: Genre.FICTION,
  },
  {
    isbn: '9780143127744',
    title: 'Pride and Prejudice',
    author: 'Jane Austen',
    publishedDate: new Date('1813-01-28T00:00:00.000Z'),
    description:
      'A romantic novel that charts the emotional development of the protagonist Elizabeth Bennet.',
    coverUrl:
      'https://storage.googleapis.com/duolibros-32a86.appspot.com/book-covers%2F1732991342702_9780143127744',
    genre: Genre.ROMANCE,
  },
  {
    isbn: '9780143127745',
    title: 'Jane Eyre',
    author: 'Charlotte Brontë',
    publishedDate: new Date('1847-10-16T00:00:00.000Z'),
    description:
      'A novel that follows the experiences of its eponymous heroine, including her growth to adulthood and her love for Mr. Rochester.',
    coverUrl:
      'https://storage.googleapis.com/duolibros-32a86.appspot.com/book-covers%2F1732991343273_9780143127745',
    genre: Genre.ROMANCE,
  },
  {
    isbn: '9780143127746',
    title: 'Steve Jobs',
    author: 'Walter Isaacson',
    publishedDate: new Date('2011-10-24T00:00:00.000Z'),
    description:
      'A biography of Steve Jobs, the co-founder of Apple Inc., based on more than forty interviews with Jobs conducted over two years.',
    coverUrl:
      'https://storage.googleapis.com/duolibros-32a86.appspot.com/book-covers%2F1732991343713_9780143127746',
    genre: Genre.BIOGRAPHY,
  },
  {
    isbn: '9781501139154',
    title: 'Becoming',
    author: 'Michelle Obama',
    publishedDate: new Date('2018-11-13T00:00:00.000Z'),
    description:
      'In her memoir, Michelle Obama chronicles the experiences that have shaped her, from her childhood on the South Side of Chicago to her years as an executive balancing the demands of motherhood and work, to her time spent at the world’s most famous address.',
    coverUrl:
      'https://storage.googleapis.com/duolibros-32a86.appspot.com/book-covers%2F1732991344140_9781501139154',
    genre: Genre.BIOGRAPHY,
  },
];
