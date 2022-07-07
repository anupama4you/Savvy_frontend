public virtual class BaseException extends Exception {
	public Set<String> messages {set;get;}
	public BaseException(Set<String> messages) {
		this.messages = messages;
	}
	public Boolean hasMultipleMessages() {
		if (this.messages != null && !this.messages.isEmpty()) {
			return true;
		}
		return false;
	}
}