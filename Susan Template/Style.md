(from CodegenC.tpl)
// - Style guidelines:
//  - Try (hard) to limit each row to 80 characters
//  - Code for a template should be indented with 2 spaces
//   - Exception to this rule is if you have only a single case, then that
//    single case can be written using no indentation
//    This single case can be seen as a clarification of the input to the
//    template
//  - Code after a case should be indented with 2 spaces if not written on the
//   same line
缩进为两个空格

因此，在我之前练习的过程中实际上搞错了

目前，OMC大部分的代码，无论是mo还是tpl的缩进都是两个空格

甚至是它生成的C语言，也是两个空格的缩进为主


(from Tpl.mo)
缩进通过空格实现
// indentation will be implemented through spaces
// where tabs will be converted where 1 tab = 4 spaces ??


当使用vscode时，向您的settings.json中添加以下内容：
尽管不一定会凑效，或者说在以前已经打开的tpl中可能不会重新生效
```json
"[susan]": {
        "editor.detectIndentation":true,
        "editor.tabSize":2,
        "editor.insertSpaces":true
    }
```