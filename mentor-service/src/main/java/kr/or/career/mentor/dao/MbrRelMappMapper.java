package kr.or.career.mentor.dao;

import kr.or.career.mentor.domain.MbrRelMapp;


public interface MbrRelMappMapper {

    /**
     * 소속 관계 메핑
     *
     * @param mbrRelMapp
     * @return
     */
    int insertMbrRelMapp(MbrRelMapp mbrRelMapp);


    /**
     * 소속 삭제
     *
     * @param targtNo
     * @return
     */
    int deleteMbrRelMappByTargt(String targtNo);


    /**
     * 대상으로 검색
     *
     * @param targtMbrNo
     * @return
     */
    MbrRelMapp getMbrRelMappByTargt(String targtMbrNo);
}
