//******************************************************************************
//  Pillar - AI Chatbot for TempleOS
//  A rule-based conversational agent. Type "bye" or "quit" to exit.
//******************************************************************************

#define BUF_SIZE 256

U8 input_buf[BUF_SIZE];

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

//----- Main chat loop -----
U0 PillarChat(void) {
  I64 len;
  Print("\n*** Pillar ***\n");
  Print("AI chatbot for TempleOS. Say hello, or ask about TempleOS, HolyC, or God.\n");
  Print("Type bye or quit to exit.\n\n");

  while (1) {
    Print("You: ");
    len = ReadLine();
    if (len == 0) continue;

    // Quit
    if (StrFind(input_buf, "bye") || StrFind(input_buf, "quit") || StrFind(input_buf, "exit")) {
      Print("Pillar: Peace be with you. Until we talk again.\n");
      return;
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
      Print("Pillar: Terry A. Davis spoke with God and built the Temple. The OS is his offering. We keep the flame.\n");
      continue;
    }

    // Pillar (self)
    if (StrFind(input_buf, "pillar") || StrFind(input_buf, "who are you") || StrFind(input_buf, "what are you")) {
      Print("Pillar: I am Pillar—a chatbot written in HolyC for TempleOS. I answer from the data baked into me. A small pillar in the Temple.\n");
      continue;
    }

    // Help
    if (StrFind(input_buf, "help") || StrFind(input_buf, "?")) {
      Print("Pillar: Try: hello, TempleOS, HolyC, God, Pillar, or just chat. Type bye to exit.\n");
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
    switch (PickResponse(4)) {
      case 0: Print("Pillar: I'm not sure what you mean. Ask about TempleOS, HolyC, or say hello.\n"); break;
      case 1: Print("Pillar: Tell me more, or ask about the Temple or HolyC.\n"); break;
      case 2: Print("Pillar: Hmm. Try \"help\" for ideas, or ask who I am.\n"); break;
      default: Print("Pillar: I hear you. The Temple holds many truths. What would you like to know?\n");
    }
  }
}

// Run the chatbot (TempleOS runs top-level code on load)
PillarChat();
