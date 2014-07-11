(* Mathematica source file *)
(* :Author: Patrick Scheibe *)
(* :Date: 7/11/14 *)

$thisDirectory = DirectoryName[$InputFileName];

(* The following code creates and exports the list of names caracters *)
$namedCharactersURL = "http://reference.wolfram.com/language/guide/ListingOfNamedCharacters.html";
webpage = Import[$namedCharactersURL, {"HTML", "Plaintext"}];
namedCharacters = StringReplace[StringCases[webpage, "\\[" ~~ Shortest[__] ~~ "]"], {"\\[" -> "", "]" -> ""}];

Print@Export[FileNameJoin[{$thisDirectory, "NamedCharacters.m"}], namedCharacters, PageWidth -> 300];


(* The next part creates the list of all builtin functions usually used.*)
(* In addition to the standard contexts, I include Developer` and Internal` since they contain often used stuff *)
makeContextNames[context_String] :=
  Append[StringReplace[
    Names[RegularExpression[context <> "`\$?[A-Z]\\w*"]],
    context ~~ "`" ~~ rest__ :> rest], context];

keywords = Sort[
  Join[Names[RegularExpression["\$?[A-Z]\\w*"]],
    makeContextNames["JLink"],
    Names[RegularExpression["(Developer|Internal)`\$?[A-Z]\\w*"]]]];

Print@Export[FileNameJoin[{$thisDirectory, "Keywords.txt"}],
  (* handle last line which is not surrounded by '' *)
  StringReplace[#, start__~~ Shortest["\n" ~~ end__ ~~ EndOfString] :> start ~~ "\n'" ~~ end ~~ "'"]&@
    StringReplace[StringJoin@Riffle[StringReplace[keywords, "$" :> "\\\\$"], "|"],
      (* make lines of length about 300*)
      Shortest[start__] ~~ "|" /; StringLength[start] > 300 :> "'" ~~ start ~~ "|'+\n"], "Text"];