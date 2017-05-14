package com.shframework.modules.dict.service.impl;

import static com.shframework.common.util.ParamsUtil.createDictQueryParamMap;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import com.shframework.common.util.Constants;
import com.shframework.common.util.PageSupport;
import com.shframework.common.util.PageTerminal;
import com.shframework.common.util.RecordDeleteUtil;
import com.shframework.modules.basic.component.CacheComponent;
import com.shframework.modules.dict.entity.DictEduGradRewardsCategory;
import com.shframework.modules.dict.entity.DictEduGradRewardsCategoryExample;
import com.shframework.modules.dict.mapper.DictEduGradRewardsCategoryMapper;
import com.shframework.modules.dict.service.DictEduGradRewardsCategoryService;

@Service
public class DictEduGradRewardsCategoryServiceImpl implements DictEduGradRewardsCategoryService {
	@Autowired
	private DictEduGradRewardsCategoryMapper dictEduGradRewardsCategoryMapper;
	private static final String defaultSortField = "_degrc.title";//默认排序字段
	private static final String defaultSortOrderby = "asc";

	@Autowired
	private CacheComponent<?> cacheComponent;
	
	@Override
	public int deleteById(int id) {
		DictEduGradRewardsCategory dict = dictEduGradRewardsCategoryMapper.selectByPrimaryKey(id);
		if (dict == null || dict.getLocked()==Constants.DICT_COMMON_YES || dict.getLogicDelete()==Constants.DICT_COMMON_YES){
			return 0;
		}
		dict.setTitle(RecordDeleteUtil.getDelValue(id, Constants.DB_COL_LENGTH_TITLE, dict.getTitle()));
		dict.setLogicDelete(Constants.DICT_COMMON_YES);//逻辑删除
		int result = dictEduGradRewardsCategoryMapper.updateByPrimaryKeySelective(dict);
		cacheComponent.renew(CacheComponent.KEY_DICT_GRAD_REWARDS_CATEGORY);
		return result;
	}

	@Override
	public PageTerminal<DictEduGradRewardsCategory> findAllByPage(
			PageSupport pageSupport) {
		pageSupport.getParamVo().getMap().put(Constants.DEFAULT_SORT_FIELD, defaultSortField);
		pageSupport.getParamVo().getMap().put(Constants.DEFAULT_SORT_ORDERBY, defaultSortOrderby);
		Map<String, Object> parMap = createDictQueryParamMap(null, pageSupport, defaultSortField + " " + defaultSortOrderby);
		int count = dictEduGradRewardsCategoryMapper.countByMap(parMap);
		List<DictEduGradRewardsCategory> gradRewardsList = null;
		if (count>0){
			gradRewardsList  =  dictEduGradRewardsCategoryMapper.selectByMap(parMap);
		}
		return new PageTerminal<DictEduGradRewardsCategory>(gradRewardsList, pageSupport, count);
	}

	@Override
	public DictEduGradRewardsCategory getDict(int id) {
		return dictEduGradRewardsCategoryMapper.selectByPrimaryKey(id);
	}

	@Override
	public int saveDict(DictEduGradRewardsCategory record) {
		try{
			if (record.getId()!=null && record.getId() > 0){
				return dictEduGradRewardsCategoryMapper.updateByPrimaryKeySelective(record);
			}
			else {
				record.setLogicDelete(Constants.DICT_COMMON_NO);
				if (record.getPriority() == null || record.getPriority() <1){
					record.setPriority(Constants.DICT_PRIORITY_DEFAULT);
				}
				return dictEduGradRewardsCategoryMapper.insertSelective(record);
			}//if-else
		} catch(DuplicateKeyException e){
			return  Constants.ERR_SAVE_DUPLICATEKEY;
		} finally {
			cacheComponent.renew(CacheComponent.KEY_DICT_GRAD_REWARDS_CATEGORY);
		}
	}
	
	@Override
	public Map<String, DictEduGradRewardsCategory> getTableMap() {
		Map<String, DictEduGradRewardsCategory> map = new LinkedHashMap<String, DictEduGradRewardsCategory>();
		DictEduGradRewardsCategoryExample example = new DictEduGradRewardsCategoryExample();
		example.createCriteria().andLogicDeleteEqualTo(Constants.BASE_LOGIC_DELETE_ZERO)
								.andStatusEqualTo(Constants.BASE_STATUS_ONE);
		List<DictEduGradRewardsCategory> list = dictEduGradRewardsCategoryMapper.selectByExample(example);
		for(DictEduGradRewardsCategory dict:list){
			map.put(""+dict.getId(), dict);
		}
		return map;
	}
}