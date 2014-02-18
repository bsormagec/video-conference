package com.andrievsky.wms.module.util;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class PairKeyMap<K1, K2, V> 
{
	private final Map<K1, K2> map1 = new HashMap<K1, K2>();
	private final Map<K2, V> map2 = new HashMap<K2, V>();
	private final Map<V, K1> map3 = new HashMap<V, K1>();
	
	public void put(K1 key1, K2 key2, V value) {
		map1.put(key1, key2);
		map2.put(key2, value);
		map3.put(value, key1);
	}
	
	public V getK1(K1 key1) {
		return map2.get(map1.get(key1));
	}
	
	public V getK2(K2 key2) {
		return map2.get(key2);
	}
	
	public K1 getKeyK1V(V value) {
		return map3.get(value);
	}
	
	public K1 getKeyK1K2(K2 key2) {
		return map3.get(map2.get(key2));
	}
	/*
	public Collection<V> getValues() {
		return map2.values();
	}
	*/
	
	public List<V> getValues() {
		return new ArrayList<V>(map2.values());
	}
	
	public Collection<K1> getK1Values() {
		return map3.values();
	}
	
	public void removeK1(K1 key1) {
		map3.remove(map2.get(map1.get(key1)));
		map2.remove(map1.get(key1));
		map1.remove(key1);
	}
	
	public void removeK2(K2 key2) {
		map1.remove(map3.get(map2.get(key2)));
		map3.remove(map2.get(key2));
		map2.remove(key2);
	}
	
	public void removeValue(V value) {
		map2.remove(map1.get(map3.get(value)));
		map1.remove(map3.get(value));
		map3.remove(value);
	}
	
	public String toString()
	{
		String result = "";
		for (K1 key1 : map1.keySet())
		{
			result += key1 +" | "+ map1.get(key1)+" | "+map2.get(map1.get(key1)) +"\n";
		}
		return result;
	}
	
	public Object toObject()
	{
		return map2.values();
	}
}
