#if !defined MLM_MAX_CHAT_LENGTH
	#define MLM_MAX_CHAT_LENGTH MAX_CHATBUBBLE_LENGTH
#endif

#if !defined MLM_MAX_PLAYER_CHAT_LENGTH
	#define MLM_MAX_PLAYER_CHAT_LENGTH (MAX_CHATBUBBLE_LENGTH / 2)
#endif

#if !defined MLM_SEPARATORS_LIST
	#define MLM_SEPARATORS_LIST ' '
#endif

#if !defined MLM_HYPHEN_END
	#define MLM_HYPHEN_END   " >"
#endif

#if !defined MLM_HYPHEN_START
	#define MLM_HYPHEN_START ">> "
#endif

static const g_MLM_HyphenEnd[] = MLM_HYPHEN_END, g_MLM_HyphenEndLength = sizeof(g_MLM_HyphenEnd) - 1, g_MLM_HyphenStart[] = MLM_HYPHEN_START, g_MLM_HyphenStartLength = sizeof(g_MLM_HyphenStart) - 1;

stock MLM_GetMessages(const message[], const array[][], lines = sizeof(array), line_size = sizeof(array[])) {
    new length = strlen(message);
    // shouldn't be shifted
    if (length <= line_size) {
        array[0][0] = '\0';
        strcat(array[0], message, line_size);
        return 1;
    }
    new bool:is_packed, last_color = -1, start_pos, end_pos, line;
    is_packed = message { 0 } != 0;
    while (end_pos < length && line < lines) {
        MLM_MakeString(array[line], line_size, message, is_packed, last_color, length, line, start_pos, end_pos, g_MLM_HyphenStart, g_MLM_HyphenStartLength, g_MLM_HyphenEnd, g_MLM_HyphenEndLength);
        line++;
    }
    return line;
}

static stock MLM_ShiftStartPos(const message[], pos, bool:is_packed, size = sizeof(message)) {
    new result_pos = pos;
    if (is_packed) {
        while (result_pos < size) {
            switch (message { result_pos }) {
                case MLM_SEPARATORS_LIST:  {
                    result_pos++;
                }
                default:  {
                    break;
                }
            }
        }
    } else {
        while (result_pos < size) {
            switch (message[result_pos]) {
                case MLM_SEPARATORS_LIST:  {
                    result_pos++;
                }
                default:  {
                    break;
                }
            }
        }
    }
    return result_pos == size ? pos : result_pos;
}

static stock MLM_ShiftEndPos(const message[], pos, bool:is_packed) {
    new result_pos = pos;
    if (is_packed) {
        while (result_pos > 0) {
            switch (message { result_pos }) {
                case MLM_SEPARATORS_LIST:  {
                    break;
                }
                default:  {
                    result_pos--;
                }
            }
        }
    } else {
        while (result_pos > 0) {
            switch (message[result_pos]) {
                case MLM_SEPARATORS_LIST:  {
                    break;
                }
                default:  {
                    result_pos--;
                }
            }
        }
    }
    return result_pos == 0 ? pos : result_pos;
}

static stock MLM_MakeString(dest[], const size = sizeof(dest), const src[], const bool:is_packed, & last_color, const length, const line, & spos, & epos, const prefix[], const prefix_length, const postfix[], const postfix_length) {
    static temp[MLM_MAX_CHAT_LENGTH + 1];
    dest[0] = '\0';
    // get pos
    spos = MLM_ShiftStartPos(src, epos, is_packed, length);
    epos = spos + size - postfix_length - (last_color != -1 ? 8 : 0);
    if (line != 0) {
        epos -= prefix_length;
    }
    if (epos >= length) {
        epos = length;
    } else {
        new shift_epos = MLM_ShiftEndPos(src, epos, is_packed);
        if (shift_epos > spos) {
            epos = shift_epos;
        }
    }
    // prefix and color
    if (line != 0) {
        // find and copy color
        for (new i = spos; i != last_color; i--) {
            if (src[i] == '}' && i - 7 >= 0 && src[i - 7] == '{') {
                strmid(dest, src, i - 7, i + 1, size);
                last_color = i - 1;
                break;
            }
        }
        // copy prefix
        strcat(dest, prefix, size);
    }
    // source
    strmid(temp, src, spos, epos);
    if (is_packed) {
        temp { epos - spos } = '\0';
    }
    strcat(dest, temp, size);
    // postfix
    if (epos != length) {
        strcat(dest, postfix, size);
    }
    return 1;
}