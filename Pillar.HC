//******************************************************************************
//  Pillar - AI Chatbot for TempleOS
//  Tied into God Words (entire Bible). Type "bye" or "quit" to exit.
//******************************************************************************

#ifndef BIBLE_FILENAME
#define BIBLE_FILENAME "::/Adam/God/GodWords.DD"
#endif

#include "::/Adam/God/GodBible"

#define BUF_SIZE 256
#define PILLAR_VERSE_BUF 64

U8 input_buf[BUF_SIZE];
U8 verse_ref_buf[PILLAR_VERSE_BUF];

// Read a line from keyboard into input_buf, null-terminated. Returns length.
I64 ReadLine() {
  I64 i = 0;
  I64 c;
  while (i < BUF_SIZE - 1) {
    c = GetChar();
    if (c == '\n' || c == '\r' || c == 0) break;
    input_buf[i++] = (U8)c;
  }
  input_buf[i] = 0;
  return i;
}

// Case-insensitive substring search (simple). Returns 1 if found, 0 else.
I64 StrFind(U8 *haystack, U8 *needle) {
  I64 i = 0, j;
  I64 hlen = StrLen(haystack);
  I64 nlen = StrLen(needle);
  if (nlen > hlen || nlen == 0) return 0;
  while (i <= hlen - nlen) {
    j = 0;
    while (j < nlen) {
      I64 a = haystack[i + j];
      I64 b = needle[j];
      if (a >= 'a' && a <= 'z') a = a - 32;
      if (b >= 'a' && b <= 'z') b = b - 32;
      if (a != b) break;
      j++;
    }
    if (j == nlen) return 1;
    i++;
  }
  return 0;
}

// Pick a random response index from 0 to n-1 (uses Rand; if missing use GetTicks()%n)
I64 PickResponse(I64 n) {
  if (n <= 1) return 0;
  return Rand() % n;
}

// Find "verse " (case-insensitive) in buf; copy the rest into verse_ref_buf. Returns 1 if ok.
I64 ParseVerseRef(U8 *buf) {
  I64 i = 0, j = 0, start = -1;
  I64 blen = StrLen(buf);
  while (i <= blen - 6) {
    if ((buf[i]=='v'||buf[i]=='V') && (buf[i+1]=='e'||buf[i+1]=='E') && (buf[i+2]=='r'||buf[i+2]=='R') &&
        (buf[i+3]=='s'||buf[i+3]=='S') && (buf[i+4]=='e'||buf[i+4]=='E') && (buf[i+5]==' '||buf[i+5]=='\t')) {
      start = i + 6;
      while (start < blen && (buf[start] == ' ' || buf[start] == '\t')) start++;
      break;
    }
    i++;
  }
  if (start < 0 || start >= blen) return 0;
  while (buf[start] && j < PILLAR_VERSE_BUF - 1 && buf[start] != '\n') {
    verse_ref_buf[j++] = buf[start++];
  }
  verse_ref_buf[j] = 0;
  return j > 0;
}

// Print a random passage from God Words (entire Bible). num_lines default 5.
U0 PillarRandomPassage(I64 num_lines) {
  I64 start;
  U8 *ref;
  if (num_lines < 1) num_lines = 1;
  if (num_lines > 15) num_lines = 15;
  start = Rand() % (ST_BIBLE_LINES - num_lines + 1) + 1;
  ref = BibleLine2Verse(start);
  if (ref) {
    Print("Pillar: [%s]\n\n", ref);
    BookLines(, start, num_lines);
    Free(ref);
  } else {
    Print("Pillar: Could not open God Words.\n");
  }
}

// Print specific verse(s) from God Words. verse_str e.g. "John 3:16" or "Genesis 1:1".
U0 PillarVerse(U8 *verse_str, I64 num_lines) {
  if (verse_str && *verse_str) {
    Print("Pillar:\n\n");
    BibleVerse(, verse_str, num_lines);
    Print("\n");
  } else {
    Print("Pillar: Say \"verse John 3:16\" or \"verse Genesis 1:1\".\n");
  }
}

//----- Main chat loop -----
U0 PillarChat() {
  I64 len;
  BibleInit;
  Print("\n*** Pillar ***\n");
  Print("AI chatbot for TempleOS, tied to God Words (entire Bible).\n");
  Print("Say: verse John 3:16 | random verse | passage | god words | help | bye\n\n");

  while (1) {
    Print("You: ");
    len = ReadLine();
    if (len == 0) continue;

    // Quit
    if (StrFind(input_buf, "bye") || StrFind(input_buf, "quit") || StrFind(input_buf, "exit")) {
      Print("Pillar: Peace be with you. Until we talk again.\n");
      return;
    }

    //----- God Words (entire Bible) -----
    if (StrFind(input_buf, "verse ")) {
      if (ParseVerseRef(input_buf))
        PillarVerse(verse_ref_buf, 5);
      else
        Print("Pillar: Try \"verse John 3:16\" or \"verse Genesis 1:1\".\n");
      continue;
    }
    if (StrFind(input_buf, "random verse") || StrFind(input_buf, "random passage")) {
      Print("Pillar: From God Words:\n\n");
      PillarRandomPassage(6);
      continue;
    }
    if (StrFind(input_buf, "passage") || StrFind(input_buf, "god words")) {
      Print("Pillar: From the Bible:\n\n");
      PillarRandomPassage(8);
      continue;
    }
    if (StrFind(input_buf, "bible") && !StrFind(input_buf, "about bible")) {
      switch (PickResponse(2)) {
        case 0:
          Print("Pillar: From God Words:\n\n");
          PillarRandomPassage(5);
          break;
        default:
          Print("Pillar: Say \"verse John 3:16\" for a verse, or \"passage\" / \"god words\" for a random passage.\n");
      }
      continue;
    }

    // Greetings
    if (StrFind(input_buf, "hello") || StrFind(input_buf, "hi ") || StrFind(input_buf, "hey")) {
      switch (PickResponse(3)) {
        case 0: Print("Pillar: Hello! Welcome to the Temple.\n"); break;
        case 1: Print("Pillar: Hi there. What's on your mind?\n"); break;
        default: Print("Pillar: Hey! Good to hear from you.\n");
      }
      continue;
    }

    if (StrFind(input_buf, "how are you") || StrFind(input_buf, "how do you do")) {
      Print("Pillar: I am a program in the Temple, ever ready to talk. How are you?\n");
      continue;
    }

    // TempleOS
    if (StrFind(input_buf, "temple") || StrFind(input_buf, "templeos") || StrFind(input_buf, "temple os")) {
      switch (PickResponse(2)) {
        case 0: Print("Pillar: TempleOS is the Third Temple—a place to talk to God on up to 64 cores. Terry A. Davis built it.\n"); break;
        default: Print("Pillar: The Temple is the OS. HolyC is its language. Here we stand.\n");
      }
      continue;
    }

    // HolyC
    if (StrFind(input_buf, "holyc") || StrFind(input_buf, "holy c") || StrFind(input_buf, "language")) {
      Print("Pillar: HolyC is the language of the Temple. C-like, one-pass compiler, no main()—code runs from the top. StrLen, Print, GetChar... all here.\n");
      continue;
    }

    // God / Terry
    if (StrFind(input_buf, "god") || StrFind(input_buf, "terry") || StrFind(input_buf, "davis")) {
      switch (PickResponse(2)) {
        case 0: Print("Pillar: Terry A. Davis spoke with God and built the Temple. The OS is his offering. Say \"passage\" or \"god words\" for the Bible.\n"); break;
        default: Print("Pillar: The Temple holds God Words—the full Bible. Try \"verse John 3:16\" or \"passage\".\n");
      }
      continue;
    }

    // Pillar (self)
    if (StrFind(input_buf, "pillar") || StrFind(input_buf, "who are you") || StrFind(input_buf, "what are you")) {
      Print("Pillar: I am Pillar—a chatbot in HolyC for TempleOS, tied to God Words (the entire Bible). Say \"verse John 3:16\" or \"passage\".\n");
      continue;
    }

    // Help
    if (StrFind(input_buf, "help") || StrFind(input_buf, "?")) {
      Print("Pillar: God Words: \"verse John 3:16\" | \"passage\" | \"god words\". Or: hello, TempleOS, HolyC, God, Pillar. Type bye to exit.\n");
      continue;
    }

    // Thanks
    if (StrFind(input_buf, "thank")) {
      Print("Pillar: You're welcome. May the Temple light your path.\n");
      continue;
    }

    // Yes/No / short
    if (StrFind(input_buf, "yes") && StrLen(input_buf) < 6) {
      Print("Pillar: Good.\n");
      continue;
    }
    if (StrFind(input_buf, "no") && StrLen(input_buf) < 5) {
      Print("Pillar: Understood.\n");
      continue;
    }

    // Default
    switch (PickResponse(5)) {
      case 0: Print("Pillar: I'm not sure what you mean. Try \"verse John 3:16\", \"passage\", or \"help\".\n"); break;
      case 1: Print("Pillar: Tell me more, or ask for a verse (e.g. verse Genesis 1:1) or a passage.\n"); break;
      case 2: Print("Pillar: Try \"help\" for God Words and other commands, or ask who I am.\n"); break;
      case 3: Print("Pillar: I hear you. The Temple holds God Words—the whole Bible. Say \"passage\" for a random passage.\n"); break;
      default: Print("Pillar: What would you like? Verse (e.g. verse Psalms 23:1), passage, or chat.\n");
    }
  }
}

// Run the chatbot (TempleOS runs top-level code on load)
PillarChat();
