package kr.or.career.mentor.util;

import lombok.SneakyThrows;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;

import java.io.File;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CodeGenerator {
    //@formatter:off
    StringBuilder listCodeSQL = new StringBuilder()
        .append("SELECT\n")
        .append("    A.cd,\n")
        .append("    A.cd_nm,\n")
        .append("    B.cd AS sup_cd,\n")
        .append("    B.cd_nm AS sup_cd_nm,\n")
        .append("    A.cd_desc,\n")
        .append("    'CD' || B.cd || '_' || A.cd || '_' || A.cd_nm AS gen_cd_nm\n")
        .append("FROM (\n")
        .append("        SELECT\n")
        .append("            DISTINCT *\n")
        .append("        FROM cnet_code\n")
        .append("        WHERE 1 = 1\n")
        .append("            AND use_yn = 'Y'\n")
        .append("        start WITH cd NOT IN (\n")
        .append("            SELECT sup_cd FROM cnet_code WHERE use_yn = 'Y'\n")
        .append("        )\n")
        .append("        connect BY NOCYCLE PRIOR sup_cd = cd\n")
        .append("    ) A, cnet_code B\n")
        .append("WHERE 1 = 1\n")
        .append("    AND A.sup_cd = B.cd(+)\n")
        .append("ORDER BY A.sup_cd, A.disp_seq\n");
    //@formatter:on

    @SneakyThrows
    public File generate() {
        List<Code> codes = loadCodes();
        if (CollectionUtils.isEmpty(codes)) {
            return null;
        }

        File file = new File("D:/", "CodeConstants.java");
        try (PrintWriter out = new PrintWriter(file)) {
            out.println("package kr.or.career.mentor.constant;\n\n");
            out.println("public class CodeConstants {\n");
            for (Code c : codes) {
                int cdDescLenght = StringUtils.length(c.cdDesc);
                out.printf("\tpublic static final String %s = \"%s\"; // %s - %s" + ((cdDescLenght > 0 && cdDescLenght < 31) ? " - (%s)\n" : "\n"),
                    c.genCdNm.replaceAll("[ ,?&\\(\\)\\.\\/·]", "_").toUpperCase(),
                    c.cd,
                    StringUtils.defaultString(c.supCdNm),
                    c.cdNm,
                    c.cdDesc);
            }
            out.println("}");
        }
        return file;
    }

    @SneakyThrows
    private List<Code> loadCodes() {
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(listCodeSQL.toString())) {
            List<Code> codeList = new ArrayList<>();

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Code code = new Code();
                code.cd = rs.getString("cd");
                code.cdNm = rs.getString("cd_nm");
                code.supCd = rs.getString("sup_cd");
                code.supCdNm = rs.getString("sup_cd_nm");
                code.genCdNm = rs.getString("gen_cd_nm");
                code.cdDesc = rs.getString("cd_desc");
                codeList.add(code);
            }
            return codeList;
        }
        catch (SQLException e) {
            throw e;
        }
    }

    @SneakyThrows
    private Connection getConnection() {
        Class.forName("oracle.jdbc.OracleDriver");
        return DriverManager.getConnection("jdbc:oracle:thin:@112.175.92.230:1521/MENTOR", "mentor_dev", "1234mentor");
    }



    class Code {
        String cd;
        String cdNm;
        String supCd;
        String supCdNm;
        String genCdNm;
        String cdDesc;
    }
}