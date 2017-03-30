/* ntels */
package kr.or.career.mentor.aop;

import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import kr.or.career.mentor.domain.Base;
import kr.or.career.mentor.util.PagedList;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.builder.IncompleteElementException;
import org.apache.ibatis.executor.Executor;
import org.apache.ibatis.executor.parameter.ParameterHandler;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.mapping.ParameterMapping;
import org.apache.ibatis.mapping.SqlSource;
import org.apache.ibatis.plugin.Interceptor;
import org.apache.ibatis.plugin.Intercepts;
import org.apache.ibatis.plugin.Invocation;
import org.apache.ibatis.plugin.Plugin;
import org.apache.ibatis.plugin.Signature;
import org.apache.ibatis.scripting.defaults.DefaultParameterHandler;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * <pre>
 * kr.or.career.mentor.aop
 *    PagingInterceptor
 *
 * 	호출하는 Mapper 의 parameter Domain 이 Pageable 일 경우 sql문에 paging기능을 추가하고 sql문의 total count를 구하는 query도 실행한다.
 * 	pageable 이 아닐 경우는 기존과 같이 실행한다.
 *
 * 	TODO save a executed query and a request's infomation by current request
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 9. 18. 오전 12:05
 */
@Intercepts({ @Signature(type = Executor.class, method = "query", args =
        { MappedStatement.class, Object.class, RowBounds.class, ResultHandler.class } )})
public class MybatisPluginInterceptor implements Interceptor {

    private final static Logger log = LoggerFactory.getLogger(MybatisPluginInterceptor.class);

    @Override
    public Object intercept(Invocation invocation) throws Throwable {
        //log.debug("invocation :: {}", invocation);

        Object paramObj = invocation.getArgs()[1];
        MappedStatement statement = (MappedStatement)invocation.getArgs()[0];

        if(paramObj == null)
            return invocation.proceed();

        try {
            Class superClass = paramObj.getClass().getSuperclass();
            Base _param = null;
            if(paramObj instanceof Base){
                _param = (Base) paramObj;
            }else{
                throw new NoSuchFieldException("parameter is not a Base class");
            }

            if (_param.isPageable()) {

                BoundSql boundSql = statement.getBoundSql(paramObj);

                String sql = statement.getBoundSql(paramObj).getSql();

                //log.debug("boundSql : {}", boundSql);

                // transform boundSql to pagination sql

                int recordCountPerPage = _param.getRecordCountPerPage();
                int currentPageNo = _param.getCurrentPageNo();

                //String prefix = "SELECT * FROM ( SELECT rownum rn, _tb.* FROM (";
                String prefix = "SELECT * FROM ( ";
                String suffix = String.format(") WHERE rn BETWEEN %d AND %d",(currentPageNo-1)*recordCountPerPage + 1,currentPageNo*recordCountPerPage);
                //String suffix = String.format(") _tb ) WHERE rn BETWEEN %d AND %d",(currentPageNo-1)*recordCountPerPage,currentPageNo*recordCountPerPage);

                //log.debug("sql :\n{}\n {}\n {}", new String[]{prefix, sql, suffix});

                // build MappedStatement
                statement = buildNewMappedStatement(statement,statement.getBoundSql(paramObj), StringUtils.join(new String[]{prefix,sql,suffix},'\n'));

                // new Invocation create and proceed.

                Object[] arguments = new Object[]{statement,invocation.getArgs()[1],invocation.getArgs()[2],invocation.getArgs()[3]};

                invocation = new Invocation(invocation.getTarget(),invocation.getMethod(),arguments);

                List result = (List)invocation.proceed();


                /**
                 *  transform boundSql to countSql and execuete countSql
                 */
                String countSql = sql.replaceAll("\n"," ").
                        replaceFirst("\\/\\*\\s*[P|p][A|a][G|g][I|i][N|n][G|g]\\s*\\*\\/\\s*.*[\\s*.*]?[S|s][E|e][L|l][E|e][C|c][T|t]\\s*.*\\/\\*\\s*[P|p][A|a][G|g][I|i][N|n][G|g]\\s*\\*\\/\\s*[F|f][R|r][O|o][M|m]", "select count(1) as cnt from ");

                PagedList<?> pagedList = new PagedList<>();
                pagedList.addAll(result);
                if(result != null && result.size() > 0){
                    Object item = result.get(0);
                    if(item instanceof Base){
                      int totalCount = executeTotalCount(statement,countSql,boundSql);
                      pagedList.setTotalCount(totalCount);
                      ((Base) item).setTotalRecordCount(totalCount);
                    }
                }

                return pagedList;
            } else {
                return invocation.proceed();
            }
        }catch (NoSuchFieldException nsf){
            return invocation.proceed();
        }

        //TODO save a executed query and a request's infomation by current request
        //log.info("user name : {}", SecurityContextHolder.getContext().getAuthentication().getPrincipal());
    }

    private MappedStatement buildNewMappedStatement(MappedStatement statement,BoundSql boundSql,String pageableSql) throws IncompleteElementException {

        BoundSql sql = new BoundSql(statement.getConfiguration(),pageableSql,boundSql.getParameterMappings(), boundSql.getParameterObject());

        for (ParameterMapping mapping : boundSql.getParameterMappings()) {
            String prop = mapping.getProperty();
            if (boundSql.hasAdditionalParameter(prop)) {
                sql.setAdditionalParameter(prop, boundSql.getAdditionalParameter(prop));
            }
        }

        BoundSqlSqlSource sqlSource = new BoundSqlSqlSource(sql);

        MappedStatement.Builder builder = new MappedStatement.Builder(statement.getConfiguration(),statement.getId(),sqlSource,statement.getSqlCommandType());
        builder.databaseId(statement.getDatabaseId());
        builder.fetchSize(statement.getFetchSize())
                .flushCacheRequired(statement.isFlushCacheRequired());
        builder.keyColumn(StringUtils.join(statement.getKeyColumns(), ','));
        builder.keyGenerator(statement.getKeyGenerator());
        builder.keyProperty(StringUtils.join(statement.getKeyProperties(), ','));
        builder.lang(statement.getLang());
        builder.parameterMap(statement.getParameterMap());
        builder.resource(statement.getResource());
        builder.resulSets(StringUtils.join(statement.getResulSets(), ','));
        builder.resultMaps(statement.getResultMaps());
        builder.resultOrdered(statement.isResultOrdered());
        builder.timeout(statement.getTimeout());
        builder.statementType(statement.getStatementType());
        builder.resultSetType(statement.getResultSetType());
        builder.cache(statement.getCache());

        return builder.build();
    }

    private int executeTotalCount(MappedStatement statement, String sql, BoundSql boundSql) throws SQLException{
        ResultSet rs = null;
        try (Connection connection = statement.getConfiguration().getEnvironment().getDataSource().getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)
        ){
            BoundSql countBoundSql = new BoundSql(statement.getConfiguration(), sql,
                    boundSql.getParameterMappings(), boundSql.getParameterObject());

            for (ParameterMapping mapping : boundSql.getParameterMappings()) {
                String prop = mapping.getProperty();
                if (boundSql.hasAdditionalParameter(prop)) {
                    countBoundSql.setAdditionalParameter(prop, boundSql.getAdditionalParameter(prop));
                }
            }


            setParameters(stmt, statement, countBoundSql, boundSql.getParameterObject());

            rs = stmt.executeQuery();
            int totalCount = 0;
            if (rs.next()) {
                totalCount = rs.getInt(1);
            }

            return totalCount;
        } catch (SQLException e) {
            throw e;
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {

                }
            }
        }
    }

    private void setParameters(PreparedStatement ps, MappedStatement mappedStatement, BoundSql boundSql,
                               Object parameterObject) throws SQLException {
        ParameterHandler parameterHandler = new DefaultParameterHandler(mappedStatement, parameterObject, boundSql);
        parameterHandler.setParameters(ps);
    }

    public static class BoundSqlSqlSource implements SqlSource {
        BoundSql boundSql;
        public BoundSqlSqlSource(BoundSql boundSql) {
            this.boundSql = boundSql;
        }
        public BoundSql getBoundSql(Object parameterObject) {
            return boundSql;
        }
    }

    @Override
    public Object plugin(Object target) {
        return Plugin.wrap(target, (Interceptor) this);
    }

    @Override
    public void setProperties(Properties properties) {

    }
}
