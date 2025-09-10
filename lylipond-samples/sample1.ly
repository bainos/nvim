\version "2.18.2"
\include "../layout/layout.ly"

\score {
  \new DrumStaff <<
    \drummode {
      \time 4/4
      <<
        \new DrumVoice {
          \voiceUP
          s4 
          r16 sn16 bd8
          s4
          sn16 sn8 bd16

          s4
          s4
          s4
          r16 sn8 bd16
        }
        \new DrumVoice {
          \voiceDOWN
          bd8 bd
          s4
          r8 bd16 bd
          s4

          r16 bd bd sn
          r16 ft bd8
          r8 bd
          s4

        }
      >>
      %\break
    }
  >>
}
