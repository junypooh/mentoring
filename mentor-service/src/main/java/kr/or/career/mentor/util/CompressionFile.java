package kr.or.career.mentor.util;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor(staticName = "of")
public class CompressionFile {

    /** 파일경로 */
    private String filepath;
    /** 파일명 */
    private String filename;
    /** 원본 파일명 */
    private String orgFilename;
}
